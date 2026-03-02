package transition.stickers;

import flixel.util.FlxSort;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxState;
import MusicBeatSubstate;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.util.FlxTimer;
import freeplay.FreeplayState;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.util.FlxSort;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Matrix;

import transition.utils.NativeFileSystem as NativeFileSystem;

using Lambda;
using StringTools;
using transition.utils.ArrayTools;
using transition.utils.IteratorTools;

class StickerSubState extends MusicBeatSubstate
{
	public static var STICKER_SET = "stickers-set-1";
	public static var STICKER_PACK = "all";

	public var grpStickers:FlxTypedGroup<StickerSprite>;

	// yes... a damn OpenFL sprite!!!
	public var dipshit:Sprite;

	/**
	 * The state to switch to after the stickers are done.
	 * This is a FUNCTION so we can pass it directly to `FlxG.switchState()`,
	 * and we can add constructor parameters in the caller.
	 */
	var targetState:StickerSubState->FlxState;

	// what "folders" to potentially load from (as of writing only "keys" exist)
	var soundSelections:Array<String> = [];
	// what "folder" was randomly selected
	var soundSelection:String = "";
	var sounds:Array<String> = [];

	public function new(?oldStickers:Array<StickerSprite>, ?targetState:StickerSubState->FlxState):Void
	{
		// controls.isInSubstate = true;
		super();

		this.targetState = (targetState == null) ? ((sticker) -> new MainMenuState()) : targetState;

		// todo still
		// make sure that ONLY plays mp3/ogg files
		// if there's no mp3/ogg file, then it regenerates/reloads the random folder

		var assetsInList = openfl.utils.Assets.list();

		var soundFilterFunc = function(a:String)
		{
			return a.startsWith('assets/shared/sounds/stickersounds/');
		};

		soundSelections = assetsInList.filter(soundFilterFunc);
		soundSelections = soundSelections.map(function(a:String)
		{
			return a.replace('assets/shared/sounds/stickersounds/', '').split('/')[0];
		});

		// cracked cleanup... yuchh...
		for (i in soundSelections)
		{
			while (soundSelections.contains(i))
			{
				soundSelections.remove(i);
			}
			soundSelections.push(i);
		}

		trace(soundSelections);

		soundSelection = FlxG.random.getObject(soundSelections);

		var filterFunc = function(a:String)
		{
			return a.startsWith('assets/shared/sounds/stickersounds/' + soundSelection + '/');
		};
		var assetsInList3 = openfl.utils.Assets.list();
		sounds = assetsInList3.filter(filterFunc);
		for (i in 0...sounds.length)
		{
			sounds[i] = sounds[i].replace('assets/shared/sounds/', '');
			sounds[i] = sounds[i].substring(0, sounds[i].lastIndexOf('.'));
		}

		trace(sounds);

		grpStickers = new FlxTypedGroup<StickerSprite>();
		add(grpStickers);

		// makes the stickers on the most recent camera, which is more often than not... a UI camera!!
		// grpStickers.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		grpStickers.cameras = FlxG.cameras.list;

		if (oldStickers != null)
		{
			for (sticker in oldStickers)
			{
				grpStickers.add(sticker);
			}

			degenStickers();
		}
		else
			regenStickers();
	}

	public function degenStickers():Void
	{
		grpStickers.cameras = FlxG.cameras.list;

		if (grpStickers.members == null || grpStickers.members.length == 0)
		{
			switchingState = false;
			close();
			return;
		}

		for (ind => sticker in grpStickers.members)
		{
			new FlxTimer().start(sticker.timer, _ ->
			{
				sticker.visible = false;
				var daSound:String = FlxG.random.getObject(sounds);

				new FlxSound().loadEmbedded(Paths.sound(daSound, "shared")).play();

				if (grpStickers == null || ind == grpStickers.members.length - 1)
				{
					switchingState = false;
					FlxTransitionableState.skipNextTransIn = false;
					close();
				}
			});
		}
	}

	function regenStickers():Void
	{
		if (grpStickers.members.length > 0)
		{
			grpStickers.clear();
		}

		trace("Collecting stickers...");
		var stickers:StickerPack = null;

		trace(STICKER_SET);
		trace(STICKER_PACK);

		#if sys
		var asStickerDir = Paths.getPath('images/stickerpacks/$STICKER_SET', TEXT, null);
		var modStickerDir = Paths.modFolders('images/stickerpacks/$STICKER_SET');
		if (!NativeFileSystem.exists(asStickerDir) && !NativeFileSystem.exists(modStickerDir))
		{
			trace("Missing sticker_set", 'Couldn\'t find sticker set "$STICKER_SET"\n\nin $asStickerDir\n\n or in$modStickerDir');
		}
		else if (!NativeFileSystem.exists('$asStickerDir/stickers.json')&&!NativeFileSystem.exists('$modStickerDir/stickers.json'))
		{
			trace("Missing manifest",
				'Sticker set $STICKER_SET doesn\'t contain a "stickers.json" file\n\nin $asStickerDir/stickers.json\n\n or in $modStickerDir/stickers.json');
		}
		else
		{
			try
			{
				var infoObj = new StickerPack(STICKER_SET);
				stickers = infoObj;
				if (infoObj.getPack(STICKER_PACK) == null)
					trace('Missing pack',
						'Sticker set ${infoObj.name} doesn\'t contain "$STICKER_PACK" pack.\n\nAll available stickers will be loaded instead.');
			}
			catch (x)
			{
				trace('Couldn\'t make $STICKER_PACK', 'In "$asStickerDir":\n\n${x.message}');
				trace('Couldn\'t make $STICKER_PACK', 'In "$modStickerDir":\n\n${x.message}');
			}
		}
		#else
		var infoObj = new StickerPack(STICKER_SET);
		stickers = infoObj;
		#end
		// sticker group -> array of sticker names

		var xPos:Float = -100;
		var yPos:Float = -100;
		while (xPos <= FlxG.width)
		{
			// A little complicateb block, so let me explain:
			var sticky:StickerSprite = null;
			// Determinate if we actually have a valid set.
			if (stickers != null)
			{
				// Select subsets defined by STICKER_PACK collection in the above "StickerSet"
				var stickerPack:Array<String> = stickers.getPack(STICKER_PACK);
				if (stickerPack == null)
				{
					stickerPack = stickers.stickers.keys().array();
				}
				// get all stickers from all subsets defined by "all" collection
				var stickerSetCollection:Array<String> = [];
				for (x in stickerPack)
				{
					stickerSetCollection = stickerSetCollection.concat(stickers.getStickers(x));
				}

				// get a random sticker
				var sticker:String = FlxG.random.getObject(stickerSetCollection);
				sticky = new StickerSprite(0, 0, STICKER_SET, sticker);
			}
			else
			{
				sticky = new StickerSprite(0, 0, null, "justBf");
			}
			sticky.visible = false;

			sticky.x = xPos;
			sticky.y = yPos;
			xPos += sticky.frameWidth * 0.5;

			if (xPos >= FlxG.width)
			{
				if (yPos <= FlxG.height)
				{
					xPos = -100;
					yPos += FlxG.random.float(70, 120);
				}
			}

			sticky.angle = FlxG.random.int(-60, 70);
			grpStickers.add(sticky);
		}

		FlxG.random.shuffle(grpStickers.members);

		// another damn for loop... apologies!!!
		for (ind => sticker in grpStickers.members)
		{
			sticker.timer = FlxMath.remapToRange(ind, 0, grpStickers.members.length, 0, 0.9);

			new FlxTimer().start(sticker.timer, _ ->
			{
				if (grpStickers == null)
					return;

				sticker.visible = true;
				var daSound:String = FlxG.random.getObject(sounds);

				new FlxSound().loadEmbedded(Paths.sound(daSound, "shared")).play();

				var frameTimer:Int = FlxG.random.int(0, 2);

				// always make the last one POP
				if (ind == grpStickers.members.length - 1)
					frameTimer = 2;

				new FlxTimer().start((1 / 24) * frameTimer, _ ->
				{
					if (sticker == null)
						return;

					sticker.scale.x = sticker.scale.y = FlxG.random.float(0.97, 1.02);

					if (ind == grpStickers.members.length - 1)
					{
						switchingState = true;

						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
						if (subState != null)
						{
							subStateClosed.addOnce(s ->
							{
								FlxG.switchState(targetState(this));
							});
						}
						else
							FlxG.switchState(targetState(this));
					}
				});
			});
		}

		trace(stickers);
		trace(STICKER_SET);
		trace(STICKER_PACK);

		grpStickers.sort((ord, a, b) ->
		{
			return FlxSort.byValues(ord, a.timer, b.timer);
		});

		// centers the very last sticker
		var lastOne:StickerSprite = grpStickers.members[grpStickers.members.length - 1];
		lastOne.updateHitbox();
		lastOne.angle = 0;
		lastOne.screenCenter();

		STICKER_SET = "stickers-set-1";
		STICKER_PACK = "all";

		WeekData.loadTheFirstEnabledMod();
	}

	var switchingState:Bool = false;

	override public function close():Void
	{
		if (switchingState)
			return;
		super.close();
	}

	override public function destroy():Void
	{
		if (switchingState)
			return;
		super.destroy();
	}
}
