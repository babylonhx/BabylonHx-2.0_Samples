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
import com.babylonhx.mesh.Mesh;
import com.babylonhx.Engine;
import com.babylonhx.Scene;
import com.babylonhx.materials.textures.CubeTexture;

class SurfaceMap {

	public function new(scene:Scene) {
		var camera = new ArcRotateCamera("Camera", 0, 0.8, 5, Vector3.Zero(), scene);
		camera.attachControl(this, false);
		
		var sun = new PointLight("Omni0", new Vector3(60, 100, 10), scene);

	    camera.setPosition(new Vector3(-20, 20, 0));
	    
	    // Skybox
	    var skybox = Mesh.CreateBox("skyBox", 100.0, scene);
	    var skyboxMaterial = new StandardMaterial("skyBox", scene);
	    skyboxMaterial.backFaceCulling = false;
	    skyboxMaterial.reflectionTexture = new CubeTexture("Assets/img/skybox/skybox", scene);
	    skyboxMaterial.reflectionTexture.coordinatesMode = Texture.SKYBOX_MODE;
	    skyboxMaterial.diffuseColor = new Color3(0, 0, 0);
	    skyboxMaterial.specularColor = new Color3(0, 0, 0);
	    skybox.material = skyboxMaterial;
	    
	    // Ground
	    var ground = Mesh.CreateGroundFromHeightMap("ground", "Assets/heightMap.png", 100, 100, 100, 0, 10, scene, false);
	    var groundMaterial = new StandardMaterial("ground", scene);
	    groundMaterial.diffuseTexture = new Texture("Assets/Ground.jpg", scene);

	    groundMaterial.diffuseTexture.uScale = 6;
	    groundMaterial.diffuseTexture.vScale = 6;
	    groundMaterial.specularColor = new Color3(0, 0, 0);
	    ground.position.y = -2.05;
	    ground.material = groundMaterial;

	    var beforeRenderFunction = function() {
	        // Camera
	        if (camera.beta < 0.1)
	            camera.beta = 0.1;
	        else if (camera.beta > (Math.PI / 2) * 0.9)
	            camera.beta = (Math.PI / 2) * 0.9;

	        if (camera.radius > 50)
	            camera.radius = 50;

	        if (camera.radius < 5)
	            camera.radius = 5;
	    };

	    scene.registerBeforeRender(beforeRenderFunction);


		scene.getEngine().runRenderLoop(function () {
            scene.render();
        });

	}

}