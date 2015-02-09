package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.display.Stage;
import flash.Lib;
import com.babylonhx.*;

import samples.Animations;
import samples.BasicElements;
import samples.BasicScene;
import samples.Collisions;
import samples.EasingFunctions;
import samples.Intersections;
import samples.Lights;
import samples.Materials;
import samples.MeshImport;
import samples.Particles;
import samples.ProceduralTextures;
import samples.RotationAndScaling;
import samples.NormalMap;
import samples.Fresenel;
import samples.SurfaceMap;
import samples.ReflectionTexture;
import samples.Particles2;
import samples.Custom_Render_Target;
import samples.Convolution;
import samples.Bloom;
import samples.Particles3;
import samples.DisplacementMap;
import samples.LinesTest;
import samples.FlareTest;
import samples.ShadowTest;


/**
 * ...
 * @author Krtolica Vujadin
 */

class Main extends Sprite {
	
	var inited:Bool;
	var scene:Scene;
	var engine:Engine;
	
	function resize(e) {
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() {
		if (inited) return;
		inited = true;

	
		
		engine = new Engine(this, false);	
		scene = new Scene(engine);
		
		#if (sample == "MeshImport")
			new MeshImport(scene);
		#elseif  (sample == "BasicScene")
			new BasicScene(scene);
		#elseif  (sample == "BasicElements")
			new BasicElements(scene, stage);
		#elseif (sample  == "RotationAndScaling")
			new RotationAndScaling(scene);
		#elseif  (sample == "Materials")
			new Materials(scene);
		#elseif (sample == "Lights")
			new Lights(scene);
		#elseif (sample == "Animations")
			new Animations(scene);
		#elseif (sample == "Collisions")
			new Collisions(scene);
		#elseif (sample == "Intersections")
			new Intersections(scene);
		#elseif (sample == "Particles")
			new Particles(scene);
		#elseif (sample == "EasingFunctions")
			new EasingFunctions(scene);
		#elseif (sample == "ProceduralTextures")
			new ProceduralTextures(scene);
		#elseif (sample == "NormalMap")
			new NormalMap(scene);
		#elseif (sample == "Fresenel")
			new Fresenel(scene);
		#elseif (sample == "SurfaceMap")
			new SurfaceMap(scene);
		#elseif (sample == "ReflectionTexture")
			new ReflectionTexture(scene);
		#elseif (sample == "Particles2")
			new Particles2(scene);
		#elseif (sample == "Custom_Render_Target")
			new Custom_Render_Target(scene, engine);
		#elseif (sample == "Convolution")
			new Convolution(scene);
		#elseif (sample == "Bloom")
			new Bloom(scene);
		#elseif (sample == "Particles3")
			new Particles3(scene, engine);
		#elseif (sample == "DisplacementMap")
			new DisplacementMap(scene);
		#elseif (sample == "LinesTest")
			new LinesTest(scene);
		#elseif (sample == "FlareTest")
			new FlareTest(scene);
		#elseif (sample == "ShadowTest")
			new ShadowTest(scene, engine);
		#else 
			new MeshImport(scene);
		#end
			
	}

	public function new() {
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) {
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}

	private function onEnterFrame(event:Event):Void
	{

		
		//this.opaqueBackground = 0xFF0000; 
	}
	
	
	public static function main() {
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
