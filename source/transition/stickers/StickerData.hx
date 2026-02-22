package transition.stickers;

typedef StickerData =
{
	/**
	 * Semantic version of the sticker set data.
	 */
	public var version:String;

	/**
	 * Readable name of the sticker set.
	 */
	public var name:String;

	/**
	 * The artist of the sticker set.
	 */
	public var artist:String;

	/**
	 * The stickers in the set.
	 * This is simply a list of asset files to use.
	 */
	public var stickers:Array<String>;
}
