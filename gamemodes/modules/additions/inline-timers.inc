forward InlineTimerCall(Func:tt<>, bool:repeat);
public InlineTimerCall(Func:tt<>, bool:repeat) {
	@.tt();
	if(!repeat) {
		Indirect_Release(tt);
	}
}

SetInlineTimer(Func:tt<>, delay, bool:repeat) {
	Indirect_Claim(tt);
	new
		timer = SetTimerEx("InlineTimerCall", delay, repeat, "ii", _:tt, _:repeat);
	Indirect_SetMeta(tt, timer);
	return _:tt;
}