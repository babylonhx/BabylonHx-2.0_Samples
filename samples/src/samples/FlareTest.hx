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
import com.babylonhx.lensflare.LensFlare;
import com.babylonhx.materials.textures.CubeTexture;
import com.babylonhx.lensflare.LensFlareSystem;

class FlareTest {

	public function new(scene:Scene) {
		var camera = new ArcRotateCamera("Camera", 0, 0.8, 5, Vector3.Zero(), scene);
		camera.attachControl(this, false);
		
		var light0 = new PointLight("Omni0", new Vector3(21.84, 50, -28.26), scene);

	    camera.alpha = 2.8;
	    camera.beta = 2.25;
	    
	    // Creating light sphere
	    var lightSphere0 = Mesh.CreateSphere("Sphere0", 16, 0.5, scene);
	    
	    var material = new StandardMaterial("white", scene);
	    material.diffuseColor = new Color3(0, 0, 0);
	    material.specularColor = new Color3(0, 0, 0);
	    material.emissiveColor = new Color3(1, 1, 1);
	    lightSphere0.material = material;

	    lightSphere0.position = light0.position;
	    
	    var lensFlareSystem = new LensFlareSystem("lensFlareSystem", light0, scene);
	    var flare00 = new LensFlare(0.2, 0, new Color3(1, 1, 1), "Assets/lens5.png", lensFlareSystem);
	    var flare01 = new LensFlare(0.5, 0.2, new Color3(0.5, 0.5, 1), "Assets/lens4.png", lensFlareSystem);
	    var flare02 = new LensFlare(0.2, 1.0, new Color3(1, 1, 1), "Assets/lens4.png", lensFlareSystem);
	    var flare03 = new LensFlare(0.4, 0.4, new Color3(1, 0.5, 1), "Assets/Flare.png", lensFlareSystem);
	    var flare04 = new LensFlare(0.1, 0.6, new Color3(1, 1, 1), "Assets/lens5.png", lensFlareSystem);
	    var flare05 = new LensFlare(0.3, 0.8, new Color3(1, 1, 1), "Assets/lens4.png", lensFlareSystem);

	    // Skybox
	    var skybox = Mesh.CreateBox("skyBox", 100.0, scene);
	    var skyboxMaterial = new StandardMaterial("skyBox", scene);
	    skyboxMaterial.backFaceCulling = false;
	    skyboxMaterial.reflectionTexture = new CubeTexture("Assets/skybox/skybox", scene);
	    skyboxMaterial.reflectionTexture.coordinatesMode = Texture.SKYBOX_MODE;
	    skyboxMaterial.diffuseColor = new Color3(0, 0, 0);
	    skyboxMaterial.specularColor = new Color3(0, 0, 0);
	    skybox.material = skyboxMaterial;

		scene.getEngine().runRenderLoop(function () {
            scene.render();
        });

	}

}