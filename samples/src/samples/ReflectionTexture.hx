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
import com.babylonhx.math.Color4;
import com.babylonhx.math.Vector3;
import com.babylonhx.mesh.Mesh;
import com.babylonhx.math.Plane;
import com.babylonhx.Engine;
import com.babylonhx.Scene;
import com.babylonhx.materials.textures.CubeTexture;
import com.babylonhx.materials.textures.MirrorTexture;
import com.babylonhx.particles.Particle;
import com.babylonhx.particles.ParticleSystem;

class ReflectionTexture {

	public function new(scene:Scene) {
		var camera = new ArcRotateCamera("Camera", 0, 0.8, 5, Vector3.Zero(), scene);
		camera.attachControl(this, false);
		
		camera.setPosition(new Vector3(-5, 5, 0));
	    camera.lowerBetaLimit = 0.1;
	    camera.upperBetaLimit = (Math.PI / 2) * 0.99;
	    camera.lowerRadiusLimit = 5;

	    // Mirror
	    
	    var mirror = Mesh.CreateBox("Mirror", 1.0, scene);
	    mirror.scaling = new Vector3(100.0, 0.01, 100.0);
	    var material = new StandardMaterial("mirror", scene);
	    material.diffuseColor = new Color3(0.4, 0.4, 0.4);
	    material.specularColor = new Color3(0, 0, 0);
	    var reflectionTexture = new MirrorTexture("mirror", 512, scene, true);
	    reflectionTexture.mirrorPlane = new Plane(0.0, -1.0, 0.0, 0.0);
	    reflectionTexture.level = 0.2;

	    material.reflectionTexture = reflectionTexture;
	    mirror.position = new Vector3(0, 0.0, 0);
	    mirror.material = material;

	    // Emitters
	    var emitter0 = Mesh.CreateBox("emitter0", 0.1, scene);
	    emitter0.isVisible = false;

	    var emitter1 = Mesh.CreateBox("emitter0", 0.1, scene);
	    emitter1.isVisible = false;

	    reflectionTexture.renderList.push(emitter0);
	    reflectionTexture.renderList.push(emitter1);

	    // Particles
	    var particleSystem = new ParticleSystem("particles", 4000, scene);
	    particleSystem.particleTexture = new Texture("Assets/Flare.png", scene);
	    particleSystem.minAngularSpeed = -0.5;
	    particleSystem.maxAngularSpeed = 0.5;
	    particleSystem.minSize = 0.1;
	    particleSystem.maxSize = 0.5;
	    particleSystem.minLifeTime = 0.5;
	    particleSystem.maxLifeTime = 2.0;
	    particleSystem.minEmitPower = 0.5;
	    particleSystem.maxEmitPower = 4.0;
	    particleSystem.emitter = emitter0;
	    particleSystem.emitRate = 400;
	    particleSystem.blendMode = ParticleSystem.BLENDMODE_ONEONE;
	    particleSystem.minEmitBox = new Vector3(-0.5, 0, -0.5);
	    particleSystem.maxEmitBox = new Vector3(0.5, 0, 0.5);
	    particleSystem.direction1 = new Vector3(-1, 1, -1);
	    particleSystem.direction2 = new Vector3(1, 1, 1);
	    particleSystem.color1 = new Color4(1, 0, 0, 1);
	    particleSystem.color2 = new Color4(0, 1, 1, 1);
	    particleSystem.gravity = new Vector3(0, -2.0, 0);
	    particleSystem.start();

	    var particleSystem2 = new ParticleSystem("particles", 4000, scene);
	    particleSystem2.particleTexture = new Texture("Assets/Flare.png", scene);
	    particleSystem2.minSize = 0.1;
	    particleSystem2.maxSize = 0.3;
	    particleSystem2.minEmitPower = 1.0;
	    particleSystem2.maxEmitPower = 2.0;
	    particleSystem2.minLifeTime = 0.5;
	    particleSystem2.maxLifeTime = 1.0;
	    particleSystem2.emitter = emitter1;
	    particleSystem2.emitRate = 500;
	    particleSystem2.blendMode = ParticleSystem.BLENDMODE_ONEONE;
	    particleSystem2.minEmitBox = new Vector3(0, 0, 0);
	    particleSystem2.maxEmitBox = new Vector3(0, 0, 0);
	    particleSystem2.gravity = new Vector3(0, -0.5, 0);
	    particleSystem2.direction1 = new Vector3(0, 0, 0);
	    particleSystem2.direction2 = new Vector3(0, 0, 0);
	    particleSystem2.start();

	    var alpha:Float = 0;
	    scene.registerBeforeRender(function () {
	        emitter1.position.x = 3 * Math.cos(alpha);
	        emitter1.position.y = 1.0;
	        emitter1.position.z = 3 * Math.sin(alpha);

	        alpha += 0.05 * scene.getAnimationRatio();
	    });



		scene.getEngine().runRenderLoop(function () {
            scene.render();
        });

	}

}