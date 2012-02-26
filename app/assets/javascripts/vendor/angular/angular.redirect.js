// https://gist.github.com/1210180
/* In place redirect using location.replace()
 *
 * Call redirect.redirect() with same arguments as $location.update()
 * Call redirect.redirectHash() with same arguments as $location.updateHash()
 *
 * $route.otherwise({redirectTo: function() {
 *     return redirect.redirectHash(...) }});
 *
 * Disuse after Vojta's $location replace is merged (0.10.1+).
 */
angular.service('redirect', function() {
  var $safe_location = angular.injector(this.$new(),
    angular.extend({}, angular.service, {
      $browser: extend_browser(angular.service.$browser),
    }))('$location');

  return {
    redirect: redirect,
    redirectHash: redirectHash,
  };

  function redirect(href) {
    $safe_location.update(href);
    location.replace($safe_location.href);
    console.log(location);
    return $safe_location.href;
  }

  function redirectHash(path, search) {
    $safe_location.updateHash(path, search);
    location.replace($safe_location.href);
    return $safe_location.hash;
  }

  // Derive a $browser service where setUrl is noop, this makes $location safe
  // to use as a url calculator.
  function extend_browser(original) {
    extended.$inject = original.$inject.splice();
    function extended() {
      X.prototype = original.apply(this, arguments);
      function X() { this.setUrl = angular.noop; }
      return new X;
    }
    return extended;
  };
}, {$inject: []});
