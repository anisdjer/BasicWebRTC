/// <reference path="knockout-2.2.1.js" />
//ViewModel stuff for knockoutjs
var Peer = function (context, storageGuid, screenName) {
    this.Context = context;
    this.StorageGuid = storageGuid;
    this.ScreenName = screenName;
};
var PeerViewModel = function () {
    var self = this;
    self.Me = new Peer(undefined, undefined, '');
    self.Peers = ko.observableArray([]);
    self.Add = function (p) {

        var match = ko.utils.arrayFirst(self.Peers(), function (item) {
            return p.StorageGuid === item.StorageGuid;
        });

        if (match) {
            self.Peers.remove(match);
        }

        self.Peers.push(new Peer(p.Context, p.StorageGuid, p.ScreenName));
    };
    self.Remove = function (p) {
        var match = ko.utils.arrayFirst(self.Peers(), function (item) {
            return p.StorageGuid === item.StorageGuid;
        });

        if (match) {
            self.Peers.remove(match);
        }
    };
};