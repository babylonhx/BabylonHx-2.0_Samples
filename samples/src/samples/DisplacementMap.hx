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
import com.babylonhx.lights.HemisphericLight;

class DisplacementMap {

	public function new(scene:Scene) {
		var camera = new ArcRotateCamera("Camera", 0, 0.8, 5, Vector3.Zero(), scene);
		camera.attachControl(this, false);
		
		var light = new HemisphericLight("Omni0", new Vector3(0, 1, 0), scene);
	    var material = new StandardMaterial("kosh", scene);
	    var sphere = Mesh.CreateSphere("Sphere", 32, 3, scene, true);

	    camera.setPosition(new Vector3(-10, 10, 0));

	    sphere.applyDisplacementMap("Assets/amiga.jpg", 0, 1.5);

	    // Sphere material
	    material.diffuseTexture = new Texture("Assets/amiga.jpg", scene);
	    sphere.material = material;

	    // Skybox
	    var skybox = Mesh.CreateBox("skyBox", 100.0, scene);
	    var skyboxMaterial = new StandardMaterial("skyBox", scene);
	    skyboxMaterial.backFaceCulling = false;
	    skyboxMaterial.reflectionTexture = new CubeTexture("Assets/skybox/skybox", scene);
	    skyboxMaterial.reflectionTexture.coordinatesMode = Texture.SKYBOX_MODE;
	    skyboxMaterial.diffuseColor = new Color3(0, 0, 0);
	    skyboxMaterial.specularColor = new Color3(0, 0, 0);
	    skybox.material = skyboxMaterial;
	    skybox.infiniteDistance = true;


		scene.getEngine().runRenderLoop(function () {
            scene.render();
        });

	}

}