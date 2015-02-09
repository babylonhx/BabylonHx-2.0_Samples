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
import com.babylonhx.mesh.VertexBuffer;

class LinesTest {

	public function new(scene:Scene) {
		var camera = new ArcRotateCamera("Camera", 0, 0.8, 5, Vector3.Zero(), scene);
		camera.attachControl(this, false);
		
		camera.setPosition(new Vector3(20, 200, 400));

	    camera.maxZ = 20000;

	    camera.lowerRadiusLimit = 150;

	    scene.clearColor = new Color3(0, 0, 0);

	    // Create a whirlpool
	    var points = [];

	    var radius = 0.5;
	    var angle:Float = 0;
	    for (index in 0...1000) {
	        points.push(new Vector3(radius * Math.cos(angle), 0, radius * Math.sin(angle)));
	        radius += 0.3;
	        angle += 0.1;
	    }

	    var whirlpool = Mesh.CreateLines("whirlpool", points, scene, true);
	    whirlpool.color = new Color3(1, 1, 1);

	    var positionData = whirlpool.getVerticesData(VertexBuffer.PositionKind);
	    var heightRange = 10;
	    var alpha:Float = 0;
	    scene.registerBeforeRender(function() {
	        for (index in 0...1000) {
	            positionData[index * 3 + 1] = heightRange * Math.sin(alpha + index * 0.1);
	        }

	        whirlpool.updateVerticesData(VertexBuffer.PositionKind, positionData);

	        alpha += 0.05 * scene.getAnimationRatio();
	    });


		scene.getEngine().runRenderLoop(function () {
            scene.render();
        });

	}

}