/**
 * Dropdown fix for navbar dropdowns
 * This script ensures that dropdown menus in the navbar work correctly.
 */

// Support for jQuery if available
(function($) {
  if (typeof $ === 'undefined') {
    return;
  }
  
  $(document).ready(function() {
    // Handle navbar toggle button for collapse menu
    var $collapseToggle = $('.navbar-toggle[data-toggle="collapse"]');
    var $collapseTarget = $('.nav-collapse');
    
    $collapseToggle.on('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      
      var target = $(this).attr('data-target');
      if (target) {
        var $target = $(target);
        if ($target.length === 0) {
          $target = $collapseTarget;
        }
        
        // Toggle the visibility
        if ($target.hasClass('in')) {
          $target.removeClass('in').slideUp();
        } else {
          $target.addClass('in').slideDown();
        }
      }
    });
    
    // Find all dropdown toggles and attach click handlers
    var $dropdownToggles = $('[data-toggle="dropdown"]');
    
    $dropdownToggles.each(function() {
      var $toggle = $(this);
      var $parent = $toggle.closest('li');
      var $menu = $parent.find('.dropdown-menu');
      
      // Make sure we have a menu
      if ($menu.length === 0) {
        $menu = $toggle.siblings('.dropdown-menu');
      }
      
      if ($menu.length > 0) {
        // Store reference to menu on the toggle for easy access
        $toggle.data('dropdown-menu', $menu);
        
        // Handle toggle click
        $toggle.on('click', function(e) {
          e.preventDefault();
          e.stopPropagation();
          
          // Close other dropdowns
          $dropdownToggles.not(this).each(function() {
            var $otherMenu = $(this).data('dropdown-menu');
            if ($otherMenu) {
              $otherMenu.removeClass('show').hide();
              $(this).closest('li').removeClass('open');
            }
          });
          
          // Toggle current dropdown
          var isVisible = $menu.hasClass('show');
          if (isVisible) {
            $menu.removeClass('show').hide();
            $parent.removeClass('open');
          } else {
            $menu.addClass('show').show();
            $parent.addClass('open');
          }
          
          return false;
        });
      }
    });
    
    // Close dropdowns when clicking outside
    $(document).on('click', function(e) {
      if (!$(e.target).closest('.dropdown').length && !$(e.target).closest('[data-toggle="dropdown"]').length) {
        $dropdownToggles.each(function() {
          var $menu = $(this).data('dropdown-menu');
          if ($menu) {
            $menu.removeClass('show').hide();
            $(this).closest('li').removeClass('open');
          }
        });
      }
    });
    
    // Close dropdowns when clicking menu items
    $dropdownToggles.each(function() {
      var $menu = $(this).data('dropdown-menu');
      if ($menu) {
        $menu.find('a').on('click', function(e) {
          // Only close if it's an external link or has href="#"
          var href = $(this).attr('href');
          if (!href || href === '#' || href.charAt(0) === '#') {
            e.preventDefault();
          }
          $menu.removeClass('show').hide();
          $menu.closest('li').removeClass('open');
        });
      }
    });
  });
})(window.jQuery || window.$);

// Fallback: Use vanilla JavaScript if jQuery is not available
if (typeof jQuery === 'undefined') {
  document.addEventListener('DOMContentLoaded', function() {
    // Handle navbar collapse toggle
    var collapseToggle = document.querySelector('.navbar-toggle[data-toggle="collapse"]');
    var collapseTarget = document.querySelector('.nav-collapse');
    
    if (collapseToggle && collapseTarget) {
      collapseToggle.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        if (collapseTarget.classList.contains('in')) {
          collapseTarget.classList.remove('in');
          collapseTarget.style.display = 'none';
        } else {
          collapseTarget.classList.add('in');
          collapseTarget.style.display = 'block';
        }
      });
    }
    
    var toggles = document.querySelectorAll('[data-toggle="dropdown"]');
    
    toggles.forEach(function(toggle) {
      toggle.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        var parent = this.closest('li');
        var menu = parent.querySelector('.dropdown-menu');
        
        if (!menu) {
          menu = this.nextElementSibling;
        }
        
        if (menu && menu.classList.contains('dropdown-menu')) {
          // Close other dropdowns
          toggles.forEach(function(otherToggle) {
            if (otherToggle !== toggle) {
              var otherParent = otherToggle.closest('li');
              var otherMenu = otherParent.querySelector('.dropdown-menu');
              if (otherMenu) {
                otherMenu.classList.remove('show');
                otherMenu.style.display = 'none';
                otherParent.classList.remove('open');
              }
            }
          });
          
          // Toggle current dropdown
          if (menu.classList.contains('show')) {
            menu.classList.remove('show');
            menu.style.display = 'none';
            parent.classList.remove('open');
          } else {
            menu.classList.add('show');
            menu.style.display = 'block';
            parent.classList.add('open');
          }
        }
        
        return false;
      });
    });
    
    // Close dropdowns when clicking outside
    document.addEventListener('click', function(e) {
      var inDropdown = e.target.closest('.dropdown');
      var isToggle = e.target.hasAttribute('data-toggle') && e.target.getAttribute('data-toggle') === 'dropdown';
      
      if (!inDropdown && !isToggle) {
        var menus = document.querySelectorAll('.dropdown-menu.show');
        menus.forEach(function(menu) {
          menu.classList.remove('show');
          menu.style.display = 'none';
          var parent = menu.closest('li');
          if (parent) {
            parent.classList.remove('open');
          }
        });
      }
    });
  });
}
