package samples;

import com.babylonhx.cameras.ArcRotateCamera;
import com.babylonhx.cameras.Camera;
import com.babylonhx.cameras.FollowCamera;
import com.babylonhx.cameras.FreeCamera;
import com.babylonhx.cameras.TargetCamera;
import com.babylonhx.lights.Light;
import com.babylonhx.lights.PointLight;
import com.babylonhx.lights.SpotLight;
import com.babylonhx.lights.DirectionalLight;
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
import com.babylonhx.mesh.Mesh;
import com.babylonhx.Engine;
import com.babylonhx.Scene;
import com.babylonhx.materials.textures.CubeTexture;
import com.babylonhx.lights.shadows.ShadowGenerator;

class ShadowTest {

	public function new(scene:Scene, engine:Engine) {
		var camera = new ArcRotateCamera("Camera", 0, 0, 10, Vector3.Zero(), scene);
		camera.attachControl(this);
		
		var light = new DirectionalLight("dir01", new Vector3(0, -1, -0.2), scene);
	    var light2 = new DirectionalLight("dir02", new Vector3(-1, -2, -1), scene);
	    light.position = new Vector3(0, 30, 0);
	    light2.position = new Vector3(10, 20, 10);

	    light.intensity = 0.6;
	    light2.intensity = 0.6;

	    camera.setPosition(new Vector3(-20, 20, 0));
	    
	    // Skybox
	    var skybox = Mesh.CreateBox("skyBox", 1000.0, scene);
	    var skyboxMaterial = new StandardMaterial("skyBox", scene);
	    skyboxMaterial.backFaceCulling = false;
	    skyboxMaterial.reflectionTexture = new CubeTexture("Assets/skybox/night", scene);
	    skyboxMaterial.reflectionTexture.coordinatesMode = Texture.SKYBOX_MODE;
	    skyboxMaterial.diffuseColor = new Color3(0, 0, 0);
	    skyboxMaterial.specularColor = new Color3(0, 0, 0);
	    skybox.material = skyboxMaterial;

	    // Ground
	    var ground = Mesh.CreateGround("ground", 1000, 1000, 1, scene, false);
	    var groundMaterial = new StandardMaterial("ground", scene);
	    if (engine.getCaps().s3tc) {
	        groundMaterial.diffuseTexture = new Texture("Assets/grass.dds", scene);
	    } else {
	        groundMaterial.diffuseTexture = new Texture("Assets/grass.jpg", scene);
	    }
	    groundMaterial.diffuseTexture.uScale = 60;
	    groundMaterial.diffuseTexture.vScale = 60;
	    groundMaterial.specularColor = new Color3(0, 0, 0);
	    ground.position.y = -2.05;
	    ground.material = groundMaterial;
	    
	    // Torus
	    var torus = Mesh.CreateTorus("torus", 8, 2, 32, scene, false);
	    torus.position.y = 6.0;
	    var torus2 = Mesh.CreateTorus("torus2", 4, 1, 32, scene, false);
	    torus2.position.y = 6.0;

	    var torusMaterial = new StandardMaterial("torus", scene);
	    torusMaterial.diffuseColor = new Color3(0.5, 0.5, 0.5);
	    torusMaterial.specularColor = new Color3(0.5, 0.5, 0.5);
	    torus.material = torusMaterial;
	    torus2.material = torusMaterial;
	    
	    // Shadows
	    var shadowGenerator = new ShadowGenerator(512, light);
	    shadowGenerator.getShadowMap().renderList.push(torus);
	    shadowGenerator.getShadowMap().renderList.push(torus2);
	    shadowGenerator.usePoissonSampling = true;
	    
	    var shadowGenerator2 = new ShadowGenerator(512, light2);
	    shadowGenerator2.getShadowMap().renderList.push(torus);
	    shadowGenerator2.getShadowMap().renderList.push(torus2);
	    shadowGenerator2.useVarianceShadowMap = true;

	    ground.receiveShadows = true;
	    
	    var beforeRenderFunction = function () {
	        // Camera
	        if (camera.beta < 0.1)
	            camera.beta = 0.1;
	        else if (camera.beta > (Math.PI / 2) * 0.99)
	            camera.beta = (Math.PI / 2) * 0.99;

	        if (camera.radius > 150)
	            camera.radius = 150;

	        if (camera.radius < 5)
	            camera.radius = 5;
	    };

	    scene.registerBeforeRender(beforeRenderFunction);
	    
	    // Animations
	    scene.registerBeforeRender(function () {
	        torus.rotation.x += 0.01;
	        torus.rotation.z += 0.02;
	        torus2.rotation.x += 0.02;
	        torus2.rotation.y += 0.01;
	    });


		scene.getEngine().runRenderLoop(function () {
            scene.render();
        });

	}

}