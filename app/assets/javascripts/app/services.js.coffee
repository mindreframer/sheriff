# http://docs.angularjs.org/#!angular.service *
angular.service('Alerts', ($resource)->
 $resource('alerts/:alert_id', {},
                  { 'index': { method: 'GET', isArray: true, params:{page:1} }});
);

angular.service('Deputies', ($resource)->
 $resource('deputies/:deputy_id', {},
                  { 'index': { method: 'GET', isArray: true, params:{page:1} }});
);

angular.service('Groups', ($resource)->
 $resource('groups/:group_id', {},
                  { 'index': { method: 'GET', isArray: true }});
);

angular.service('SelectedPhotos', ($resource)->
 $resource('selected_photos/:selected_photo_id', {},
                      'create': { method: 'POST' },
                      'index':  { method: 'GET', isArray: true },
                      'update': { method: 'PUT' },
                      'destroy': { method: 'DELETE' });
);
