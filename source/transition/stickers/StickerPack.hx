package transition.stickers;

import transition.stickers.StickerData;

class StickerPack
{
	public final id:String;
	public final _data:StickerData;

	public function new(id:String, ?params:Dynamic)
	{
		this.id = id;
		this._data = _fetchData(id);

		if (_data == null)
		{
			throw 'Could not parse sticker pack data for id: $id';
		}
	}

	public function getStickers():Array<String>
	{
		return _data.stickers;
	}

	public function getRandomStickerPath(last:Bool):String
	{
		return FlxG.random.getObject(getStickers());
	}

	public function toString():String
	{
		return 'StickerPack($id)';
	}
}
