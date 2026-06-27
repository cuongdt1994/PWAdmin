/**
 * ╔══════════════════════════════════════════════════════════════╗
 * ║           PHOENIX UI - JavaScript Utilities                ║
 * ║     Perfect World Admin Panel - Interactive Components    ║
 * ╚══════════════════════════════════════════════════════════════╝
 */

// ===== SIDEBAR TOGGLE (Mobile) =====
function phxSidebar() {
    return {
        open: window.innerWidth > 1024,
        init() {
            const self = this;
            window.addEventListener('resize', () => {
                self.open = window.innerWidth > 1024;
            });
        },
        toggle() {
            this.open = !this.open;
        },
        close() {
            this.open = false;
        }
    };
}

// ===== TOAST NOTIFICATION SYSTEM =====
const Toast = {
    _container: null,

    _getContainer() {
        if (!this._container) {
            this._container = document.createElement('div');
            this._container.className = 'phx-toast-container';
            document.body.appendChild(this._container);
        }
        return this._container;
    },

    show(message, type, duration) {
        type = type || 'info';
        duration = duration || 5000;

        const container = this._getContainer();
        const icons = {
            success: 'fa-solid fa-circle-check',
            error: 'fa-solid fa-circle-xmark',
            warning: 'fa-solid fa-triangle-exclamation',
            info: 'fa-solid fa-circle-info'
        };

        const toast = document.createElement('div');
        toast.className = 'phx-toast phx-toast-' + type;
        toast.innerHTML =
            '<i class="' + (icons[type] || icons.info) + '"></i>' +
            '<span class="phx-toast-msg">' + message.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;') + '</span>' +
            '<button class="phx-toast-close" onclick="this.parentElement.remove()">' +
            '<i class="fa-solid fa-xmark"></i></button>';

        container.appendChild(toast);

        if (duration > 0) {
            setTimeout(() => {
                if (toast.parentElement) {
                    toast.style.opacity = '0';
                    toast.style.transform = 'translateX(40px)';
                    toast.style.transition = 'all 300ms ease';
                    setTimeout(() => { if (toast.parentElement) toast.remove(); }, 300);
                }
            }, duration);
        }

        return toast;
    },

    success(msg, dur) { return this.show(msg, 'success', dur); },
    error(msg, dur)   { return this.show(msg, 'error', dur); },
    warning(msg, dur) { return this.show(msg, 'warning', dur); },
    info(msg, dur)    { return this.show(msg, 'info', dur); }
};

// ===== CONFIRM DIALOG =====
function phxConfirm(message, callback) {
    if (confirm(message)) {
        if (typeof callback === 'function') callback();
        return true;
    }
    return false;
}

// ===== MAP MANAGER (Alpine.js component for map grid selector) =====
function phxMapManager(mapsData) {
    return {
        maps: mapsData || [],
        selected: [],
        search: '',

        get filteredMaps() {
            if (!this.search.trim()) return this.maps;
            const q = this.search.toLowerCase();
            return this.maps.filter(function(m) {
                return m.id.toLowerCase().includes(q) ||
                       m.name.toLowerCase().includes(q);
            });
        },

        get selectedCount() {
            return this.selected.length;
        },

        isSelected(map) {
            return this.selected.indexOf(map.id) !== -1;
        },

        toggleMap(map) {
            const idx = this.selected.indexOf(map.id);
            if (idx !== -1) {
                this.selected.splice(idx, 1);
            } else {
                this.selected.push(map.id);
            }
        },

        selectAll() {
            this.selected = this.filteredMaps.map(function(m) { return m.id; });
        },

        deselectAll() {
            this.selected = [];
        },

        getSelectedValues() {
            return this.selected;
        }
    };
}

// ===== TAB MANAGER =====
function phxTabs() {
    return {
        activeTab: null,
        init(tabId) {
            this.activeTab = tabId;
        },
        setTab(tabId) {
            this.activeTab = tabId;
        },
        isActive(tabId) {
            return this.activeTab === tabId;
        }
    };
}

// ===== COLLAPSE MANAGER =====
function phxCollapse() {
    return {
        open: false,
        toggle() {
            this.open = !this.open;
        }
    };
}

// ===== FORMAT UTILITIES =====
function phxFmtNumber(n) {
    if (n == null) return '0';
    return n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

function phxFmtBytes(bytes) {
    if (bytes == null) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    let i = 0;
    while (bytes >= 1024 && i < units.length - 1) {
        bytes /= 1024;
        i++;
    }
    return bytes.toFixed(i > 0 ? 1 : 0) + ' ' + units[i];
}

// ===== INITIALIZATION =====
document.addEventListener('DOMContentLoaded', function() {
    // Close sidebar when clicking overlay on mobile
    const overlay = document.querySelector('.phx-sidebar-overlay');
    if (overlay) {
        overlay.addEventListener('click', function() {
            const sidebar = document.querySelector('.phx-sidebar');
            if (sidebar) sidebar.classList.remove('open');
            overlay.classList.remove('show');
        });
    }
});
