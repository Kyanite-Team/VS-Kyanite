package transition.stickers;

import haxe.Json;

class StickerPack
{
	public var name:String;
	public var artist:String;
	public var modDir:String;
	public var stickers:Map<String, Array<String>>;
	public var stickerPacks:Map<String, Array<String>>;

	public function new(stickerSet:String):Void
	{
		var json = Json.parse(Paths.getTextFromFile('images/stickerpacks/${StickerSubState.STICKER_SET}/stickers.json'));

		// doin this dipshit nonsense cuz i dunno how to deal with casting a json object with
		// a dash in its name (sticker-packs)
		var jsonInfo:StickerData = cast json;

		this.name = jsonInfo.name;
		this.artist = jsonInfo.artist;

		stickerPacks = new Map<String, Array<String>>();

		for (field in Reflect.fields(json.stickerPacks))
		{
			var stickerFunny = json.stickerPacks;
			var stickerStuff = Reflect.field(stickerFunny, field);

			stickerPacks.set(field, cast stickerStuff);
		}

		// creates a similar for loop as before but for the stickers
		stickers = new Map<String, Array<String>>();

		for (field in Reflect.fields(json.stickers))
		{
			var stickerFunny = json.stickers;
			var stickerStuff = Reflect.field(stickerFunny, field);

			stickers.set(field, cast stickerStuff);
		}
	}

	public function getStickers(stickerName:String):Array<String>
	{
		return this.stickers[stickerName];
	}

	public function getPack(packName:String):Array<String>
	{
		return this.stickerPacks[packName];
	}
}
