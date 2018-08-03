trigger AccountAddressTrigger on Account (before insert) {
	System.debug('Hello World!');
}