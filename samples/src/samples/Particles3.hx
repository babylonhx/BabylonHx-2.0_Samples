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
import com.babylonhx.Engine;
import com.babylonhx.Scene;
import com.babylonhx.particles.Particle;
import com.babylonhx.particles.ParticleSystem;
import com.babylonhx.animations.Animation;

class Particles3 {

	public function new(scene:Scene, engine:Engine) {
		var camera = new ArcRotateCamera("Camera", 0, 0.8, 5, Vector3.Zero(), scene);
		camera.attachControl(this, false);
		
		camera.setPosition(new Vector3(-5, 5, 0));
	    camera.lowerBetaLimit = 0.1;
	    camera.upperBetaLimit = (Math.PI / 2) * 0.95;
	    camera.lowerRadiusLimit = 5;

	    // Emitters
	    var emitter0 = Mesh.CreateBox("emitter0", 0.1, scene);
	    emitter0.isVisible = false;

	    // Custom shader for particles
	  
	     ShadersStore.Shaders.set("myparticle.fragment",
	    "#ifdef GL_ES\n" +
	    "precision highp float;\n" +
	    "#endif\n" +

	    "varying vec2 vUV;\n" +                     // Provided by js
	    "varying vec4 vColor;\n" +                  // Provided by js

	    "uniform sampler2D diffuseSampler;\n" +     // Provided by js
	    "uniform float time;\n" +                   // This one is custom so we need to declare it to the effect

	    "void main(void) {\n" +
	        "vec2 position = vUV;\n" +

	        "float color = 0.0;\n" +
	        "vec2 center = vec2(0.5, 0.5);\n" +
		
	        "color = sin(distance(position, center) * 10.0+ time * vColor.g);\n" +

	        "vec4 baseColor = texture2D(diffuseSampler, vUV);\n" +

	        "gl_FragColor = baseColor * vColor * vec4( vec3(color, color, color), 1.0 );\n" +
	    "}\n" +
	    "");





	    // Effect
	    var effect = engine.createEffectForParticles("myparticle", ["time"]);

	    // Particles
	    var particleSystem = new ParticleSystem("particles", 4000, scene, effect);
	    particleSystem.particleTexture = new Texture("Assets/Flare.png", scene);
	    particleSystem.minSize = 0.1;
	    particleSystem.maxSize = 1.0;
	    particleSystem.minLifeTime = 0.5;
	    particleSystem.maxLifeTime = 5.0;
	    particleSystem.minEmitPower = 0.5;
	    particleSystem.maxEmitPower = 3.0;
	    particleSystem.emitter = emitter0;
	    particleSystem.emitRate = 100;
	    particleSystem.blendMode = ParticleSystem.BLENDMODE_ONEONE;
	    particleSystem.direction1 = new Vector3(-1, 1, -1);
	    particleSystem.direction2 = new Vector3(1, 1, 1);
	    particleSystem.color1 = new Color4(1, 1, 0, 1);
	    particleSystem.color2 = new Color4(1, 0.5, 0, 1);
	    particleSystem.gravity = new Vector3(0, -1.0, 0);
	    particleSystem.start();

	    var time:Float = 0;
	    var order = 0.1;

	    scene.registerBeforeRender(function () {
	        // Waiting for effect to be compiled
	        if (effect != null) {
	            return;
	        }

	        effect.setFloat("time", time);

	        time += order;

	        if (time > 100 || time < 0) {
	            order *= -1;
	        }
	    });

		scene.getEngine().runRenderLoop(function () {
            scene.render();
        });

	}

}