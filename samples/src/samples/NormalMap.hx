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

class NormalMap {

	public function new(scene:Scene) {
		var camera = new ArcRotateCamera("Camera", 0, 0.8, 5, Vector3.Zero(), scene);
		camera.attachControl(this, false);
		
		var light = new PointLight("Omni", new Vector3(20, 100, 2), scene);
		var sphere = Mesh.CreateSphere("Sphere", 16, 3, scene);
		var material = new StandardMaterial("kosh", scene);
		material.diffuseColor = new Color3(1, 0, 0);    
		sphere.material = material;    

		material.bumpTexture = new Texture("Assets/img/normalMap.jpg", scene);

		scene.registerBeforeRender(function() {
		     sphere.rotation.y += 0.02;
		});

		scene.getEngine().runRenderLoop(function () {
            scene.render();
        });

	}

}