var Audio = function () {
    var audioBuffers = {};
    var context = new webkitAudioContext();
    var currentSource = undefined;
    this.load = function (key, url) {
        var request = new XMLHttpRequest();
        request.open('GET', url, true);
        request.responseType = 'arraybuffer';
        request.onload = function () {
            context.decodeAudioData(request.response, function (buffer) {
                audioBuffers[key] = buffer;
            }, function () { });
        };
        request.send();
    };
    this.play = function (key) {
        currentSource = context.createBufferSource();
        currentSource.buffer = audioBuffers[key];
        currentSource.connect(context.destination);
        currentSource.noteOn(0);
    };
    this.stop = function () {
        if (currentSource !== undefined) {
            currentSource.noteOff(0);
            currentSource = undefined;
        }
    };
};