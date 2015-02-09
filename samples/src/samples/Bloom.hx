package samples;

import com.babylonhx.cameras.ArcRotateCamera;
import com.babylonhx.cameras.Camera;
import com.babylonhx.cameras.FollowCamera;
import com.babylonhx.cameras.FreeCamera;
import com.babylonhx.cameras.TargetCamera;
import com.babylonhx.lights.Light;
import com.babylonhx.lights.PointLight;
import com.babylonhx.lights.SpotLight;
import com.babylonhx.loading.plugins.BabylonFileLoader;
import com.babylonhx.loading.SceneLoader;
import com.babylonhx.materials.textures.Texture;
import com.babylonhx.materials.Effect;
import com.babylonhx.materials.Material;
import com.babylonhx.materials.MultiMaterial;
import com.babylonhx.materials.ShaderMaterial;
import com.babylonhx.materials.ShadersStore;
import com.babylonhx.materials.StandardMaterial;
import com.babylonhx.math.Color3;
import com.babylonhx.math.Vector3;
import com.babylonhx.math.Vector2;
import com.babylonhx.mesh.Mesh;
import com.babylonhx.Engine;
import com.babylonhx.Scene;
import com.babylonhx.lights.DirectionalLight;
import com.babylonhx.materials.textures.CubeTexture;
import com.babylonhx.postprocess.BlurPostProcess;
import com.babylonhx.postprocess.ConvolutionPostProcess;
import com.babylonhx.postprocess.DisplayPassPostProcess;
import com.babylonhx.postprocess.PassPostProcess;
import com.babylonhx.postprocess.PostProcess;

class Bloom {

	public function new(scene:Scene) {
		var camera = new ArcRotateCamera("Camera", 0, 0.8, 5, Vector3.Zero(), scene);
		camera.attachControl(this, false);
		
		var light = new DirectionalLight("dir01", new Vector3(0, -1, -0.2), scene);
	    var light2 = new DirectionalLight("dir02", new Vector3(-1, -2, -1), scene);
	    light.position = new Vector3(0, 30, 0);
	    light2.position = new Vector3(10, 20, 10);

	    light.intensity = 0.6;
	    light2.intensity = 0.6;

	    camera.setPosition(new Vector3(-40, 40, 0));
	    camera.lowerBetaLimit = (Math.PI / 2) * 0.9;
	    
	    // Skybox
	    var skybox = Mesh.CreateBox("skyBox", 1000.0, scene);
	    var skyboxMaterial = new StandardMaterial("skyBox", scene);
	    skyboxMaterial.backFaceCulling = false;
	    skyboxMaterial.reflectionTexture = new CubeTexture("Assets/skybox/snow", scene);
	    skyboxMaterial.reflectionTexture.coordinatesMode = Texture.SKYBOX_MODE;
	    skyboxMaterial.diffuseColor = new Color3(0, 0, 0);
	    skyboxMaterial.specularColor = new Color3(0, 0, 0);
	    skybox.material = skyboxMaterial;
	    
	    // Spheres
	    var sphere0 = Mesh.CreateSphere("Sphere0", 16, 10, scene);
	    var sphere1 = Mesh.CreateSphere("Sphere1", 16, 10, scene);
	    var sphere2 = Mesh.CreateSphere("Sphere2", 16, 10, scene);
	    var cube = Mesh.CreateBox("Cube", 10.0, scene);

	    var material = new StandardMaterial("white", scene);
	    material.diffuseColor = new Color3(0, 0, 0);
	    material.specularColor = new Color3(0, 0, 0);
	    material.emissiveColor = new Color3(1.0, 1.0, 1.0);
	    sphere0.material = material;

	    sphere1.material = sphere0.material;
	    sphere2.material = sphere0.material;
	    
	    var mat = new StandardMaterial("red", scene);
	    mat.diffuseColor = new Color3(0, 0, 0);
	    mat.specularColor = new Color3(0, 0, 0);
	    mat.emissiveColor = new Color3(1.0, 0, 0);
	    cube.material = mat;
	       
	    // Post-process
	    var blurWidth = 1.0;
	    
	    var postProcess0 = new PassPostProcess("Scene copy", 1.0, camera, 2);
	    var postProcess1 = new PostProcess("Down sample", "downsample", ["screenSize", "highlightThreshold"], null, 0.25, camera, Texture.BILINEAR_SAMPLINGMODE);
	    postProcess1.onApply = function (effect) {
	        effect.setFloat2("screenSize", postProcess1.width, postProcess1.height);
	        effect.setFloat("highlightThreshold", 0.90);
	    };
	    var postProcess2 = new BlurPostProcess("Horizontal blur", new Vector2(1.0, 0), blurWidth, 0.25, camera);
	    var postProcess3 = new BlurPostProcess("Vertical blur", new Vector2(0, 1.0), blurWidth, 0.25, camera);
	    var postProcess4 = new PostProcess("Final compose", "compose", ["sceneIntensity", "glowIntensity", "highlightIntensity"], ["sceneSampler"], 1, camera);
	    postProcess4.onApply = function (effect) {
	        effect.setTextureFromPostProcess("sceneSampler", postProcess0);
	        effect.setFloat("sceneIntensity", 0.5);
	        effect.setFloat("glowIntensity", 0.4);
	        effect.setFloat("highlightIntensity", 1.0);
	    };
	    
	    // Animations
	    var alpha:Float = 0;
	    scene.registerBeforeRender(function() {
	        sphere0.position = new Vector3(20 * Math.sin(alpha), 0, 20 * Math.cos(alpha));
	        sphere1.position = new Vector3(20 * Math.sin(alpha), 0, -20 * Math.cos(alpha));
	        sphere2.position = new Vector3(20 * Math.cos(alpha), 0, 20 * Math.sin(alpha));

	        cube.rotation.y += 0.01;
	        cube.rotation.z += 0.01;

	        alpha += 0.01;
	    });

		scene.getEngine().runRenderLoop(function () {
            scene.render();
        });

	}

}