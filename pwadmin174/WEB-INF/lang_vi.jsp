<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    ╔══════════════════════════════════════════════════════════════╗
    ║           PWADMIN 1.7.4 - TIẾNG VIỆT (UTF-8)               ║
    ║     Tập tin ngôn ngữ tập trung - SỬA Ở ĐÂY CHO MỌI TRANG   ║
    ╚══════════════════════════════════════════════════════════════╝

    Cách sử dụng trong các trang JSP:
      1. Include file này bằng JSP include directive trong trang cần sử dụng
      2. Dùng hàm T("key") hoặc Tf("key", args) để lấy chuỗi
      3. Nếu key không tồn tại, sẽ hiển thị key gốc (an toàn, không lỗi)

    ĐỂ SỬA TIẾNG VIỆT: Chỉ cần sửa file này, không cần đụng vào các trang JSP.
    ĐỂ THÊM NGÔN NGỮ MỚI: Copy file này thành lang_en.jsp, lang_zh.jsp, v.v...
--%>
<%!
    private static final java.util.Map<String, String> L = new java.util.HashMap<String, String>();

    static {

    // ╔══════════════════════════════════════════════════════════════╗
    // ║                   THANH ĐIỀU HƯỚNG (NAVBAR)                ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("app.brand",           "PWADMIN 1.7.4");
    L.put("nav.settings",        "Cài đặt");
    L.put("nav.accounts",        "Tài khoản");
    L.put("nav.characters",      "Nhân vật");
    L.put("nav.server_config",   "Cấu hình Server");
    L.put("nav.server_control",  "Điều khiển Server");
    L.put("nav.addons",          "ADDONS");
    L.put("nav.no_addons",       "Không có add-on nào");
    L.put("nav.search_plugins",  "Tìm Plugin...");
    L.put("nav.logout",          "Đăng xuất");
    L.put("nav.access_denied",   "Truy cập bị từ chối. Chuyển về trang mặc định.");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║                   TRANG ĐĂNG NHẬP (LOGIN)                  ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("login.title",              "Đăng nhập Quản trị");
    L.put("login.username",           "Tên đăng nhập:");
    L.put("login.password",           "Mật khẩu:");
    L.put("login.button",             "Đăng nhập");
    L.put("login.logout",             "Đăng xuất");
    L.put("login.captcha_q",          "Kết quả của %d + %d là gì?");
    L.put("login.error.invalid",      "Sai tên đăng nhập hoặc mật khẩu.");
    L.put("login.error.captcha",      "Sai mã xác nhận (CAPTCHA).");
    L.put("login.error.ip_denied",    "Truy cập bị từ chối, IP của bạn (%s) không có trong danh sách cho phép.");
    L.put("login.error.db",           "Lỗi cơ sở dữ liệu: %s");
    L.put("login.error.whitelist",    "Lỗi đọc file whitelist.");
    L.put("login.error.store_creds",  "Lỗi lưu thông tin đăng nhập: %s");
    L.put("login.initial_title",      "Thiết lập Tài khoản Admin");
    L.put("login.initial_desc",       "Đây là lần đăng nhập đầu tiên. Vui lòng tạo tài khoản admin.");
    L.put("login.create_admin_btn",   "Tạo Tài khoản Admin");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║              ĐIỀU KHIỂN SERVER (SERVERCTRL)                ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("sctrl.login_required",    "Đăng nhập để Điều khiển Server...");
    L.put("sctrl.memory_daemon",     "Bộ nhớ & Dịch vụ");
    L.put("sctrl.ram_usage",         "RAM Đã dùng");
    L.put("sctrl.swap_usage",        "Swap Đã dùng");
    L.put("sctrl.game_services",     "Trạng thái Dịch vụ Game");
    L.put("sctrl.logservice",        "Logservice");
    L.put("sctrl.auth_daemon",       "Gauth Daemon");
    L.put("sctrl.unique_name",       "Unique Name Daemon");
    L.put("sctrl.anti_cheat",        "Game Anti-Cheat Daemon");
    L.put("sctrl.faction",           "Faction Daemon");
    L.put("sctrl.delivery",          "Game Delivery Daemon");
    L.put("sctrl.link",              "Game Link Daemon");
    L.put("sctrl.database",          "Game Database Daemon");
    L.put("sctrl.map_service",       "Dịch vụ Bản đồ");
    L.put("sctrl.server_start",      "Khởi động / Dừng Server");
    L.put("sctrl.start_server_btn",  "Khởi động Server");
    L.put("sctrl.stop_server_btn",   "Dừng Server");
    L.put("sctrl.maps",              "Bản đồ");
    L.put("sctrl.stop_all_maps",     "Dừng Tất Cả Bản đồ");
    L.put("sctrl.delay_seconds",     "Thời gian trễ (giây):");
    L.put("sctrl.online_maps",       "Bản đồ Đang Chạy: %d");
    L.put("sctrl.available_maps",    "Bản đồ Có Sẵn");
    L.put("sctrl.stop_selected",     "Dừng Bản đồ Đã Chọn");
    L.put("sctrl.start_selected",    "Khởi động Bản đồ Đã Chọn");
    L.put("sctrl.msg.server_off",    "Server Đã Tắt");
    L.put("sctrl.msg.server_starting","Server Đang Khởi Động... có thể mất vài phút để server hoạt động hoàn chỉnh. Bản đồ Thế Giới (gs01) đang được tự động khởi động.");
    L.put("sctrl.msg.server_off_fail","Tắt Server Thất Bại");
    L.put("sctrl.msg.server_start_fail","Khởi Động Server Thất Bại: ");
    L.put("sctrl.msg.maps_stopping", "Tất cả Bản đồ sẽ dừng sau %d giây");
    L.put("sctrl.msg.maps_stop_fail", "Đặt hẹn giờ dừng Bản đồ Thất Bại");
    L.put("sctrl.msg.maps_stopped",  "Bản đồ Đã Được Dừng");
    L.put("sctrl.msg.maps_started",  "Bản đồ Đã Được Khởi Động");
    L.put("sctrl.msg.maps_stop_fail2","Dừng Bản đồ Thất Bại");
    L.put("sctrl.msg.maps_start_fail","Khởi Động Bản đồ Thất Bại");
    L.put("sctrl.msg.backup_started", "Đã Bắt Đầu Sao Lưu -> ");
    L.put("sctrl.msg.backup_failed",  "Sao Lưu Thất Bại");
    L.put("sctrl.msg.backup_running", "Đang có Sao Lưu Server chạy, vui lòng đợi đến khi hoàn tất! Nhấn <a href=\"index.jsp?page=serverctrl\">vào đây</a> để kiểm tra lại...");
    L.put("sctrl.msg.gs01_starting",  "Đã tự động khởi động 2 map mặc định: gs01 (Thế Giới) + is61 (Điểm Bắt Đầu)...");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║                TÊN BẢN ĐỒ (MAP NAMES)                      ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("map.gs01",    "Thế Giới");
    L.put("map.is01",    "Thành Phố Tội Lỗi");
    L.put("map.is02",    "Đường Hầm Bí Mật");
    L.put("map.is05",    "Hang Lửa");
    L.put("map.is06",    "Hang Sói Điên");
    L.put("map.is07",    "Hang Quái Vật");
    L.put("map.is08",    "Sảnh Lừa Dối");
    L.put("map.is09",    "Cổng Mê Sảng");
    L.put("map.is10",    "Khu Đất Băng Giá Bí Mật");
    L.put("map.is11",    "Thung Lũng Thảm Họa");
    L.put("map.is12",    "Tàn Tích Rừng");
    L.put("map.is13",    "Hang Khoái Lạc Độc Ác");
    L.put("map.is14",    "Cổng Ma");
    L.put("map.is15",    "Rãnh Ảo Giác");
    L.put("map.is16",    "Địa Đàng");
    L.put("map.is17",    "Hố Lưu Huỳnh");
    L.put("map.is18",    "Đền Rồng");
    L.put("map.is19",    "Đảo Tiếng Thét Đêm");
    L.put("map.is20",    "Đảo Rắn");
    L.put("map.is21",    "Lothranis");
    L.put("map.is22",    "Momaganon");
    L.put("map.is23",    "Ngai Khổ Hình");
    L.put("map.is24",    "Vực Thẳm");
    L.put("map.is25",    "Thành Chiến Ca");
    L.put("map.is26",    "Cung Điện Niết Bàn");
    L.put("map.is27",    "Rừng Trăng");
    L.put("map.is28",    "Thung Lũng Tương Hỗ");
    L.put("map.is29",    "Thành Băng Giá");
    L.put("map.is31",    "Đền Hoàng Hôn");
    L.put("map.is32",    "Khối Lập Phương Định Mệnh");
    L.put("map.is33",    "Thành Thời Gian");
    L.put("map.is34",    "Nhà Nguyện Hoàn Mỹ");
    L.put("map.is35",    "Căn Cứ Bang Hội");
    L.put("map.is37",    "Morai");
    L.put("map.is38",    "Thung Lũng Phượng Hoàng");
    L.put("map.is39",    "Vũ Trụ Vô Tận");
    L.put("map.is40",    "Phòng Bệnh Dịch");
    L.put("map.is41",    "Vũ Trụ Vô Tận");
    L.put("map.is42",    "Hẻm Chiến Thần");
    L.put("map.is43",    "Ngũ Đế");
    L.put("map.is44",    "Chiến Tranh Quốc Gia 2");
    L.put("map.is45",    "Tháp Chiến Tranh Quốc Gia");
    L.put("map.is46",    "Pha Lê Chiến Tranh Quốc Gia");
    L.put("map.is47",    "Thung Lũng Hoàng Hôn");
    L.put("map.is48",    "Cung Điện Che Đậy");
    L.put("map.is49",    "Hang Rồng Ẩn");
    L.put("map.is50",    "Cõi Phản Chiếu");
    L.put("map.is61",    "Điểm Bắt Đầu");
    L.put("map.is62",    "Khởi Nguyên");
    L.put("map.is63",    "Thế Giới Nguyên Thủy");
    L.put("map.is66",    "Cung Điện Bạc Chảy");
    L.put("map.is67",    "Sảnh Ngầm");
    L.put("map.is68",    "Cõi Phàm Trần");
    L.put("map.is69",    "Hang Ánh Đèn");
    L.put("map.is70",    "Khối Định Mệnh (2)");
    L.put("map.is71",    "Chiến Rồng");
    L.put("map.is72",    "Đền Trời Rơi");
    L.put("map.is73",    "Đền Trời Rơi");
    L.put("map.is74",    "Đền Trời Rơi");
    L.put("map.is75",    "Đền Trời Rơi");
    L.put("map.is76",    "Thiên Đường Hoang Sơ");
    L.put("map.is77",    "Ngã Tư Đánh Thurs");
    L.put("map.is78",    "Thảo Nguyên Phía Tây");
    L.put("map.is80",    "Trang Viên Trên Mây");
    L.put("map.is81",    "Trang Viên Trên Mây");
    L.put("map.is82",    "Trang Viên Trên Mây");
    L.put("map.is83",    "Trang Viên Trên Mây");
    L.put("map.is84",    "Thung Lũng Nho");
    L.put("map.is85",    "Bảo Tàng Nemesis");
    L.put("map.is86",    "Sảnh Bình Minh (DR 1)");
    L.put("map.is87",    "Hồ Ảo Ảnh");
    L.put("map.is88",    "Tàn Tích Sa Mạc Hồng");
    L.put("map.is89",    "Rừng Ác Mộng");
    L.put("map.is90",    "Phòng Cố Vấn (DR 2)");
    L.put("map.is91",    "Xứ Sở Thần Tiên (Công Viên)");
    L.put("map.is92",    "Thành Phố Không Thể Phá Hủy");
    L.put("map.is93",    "Đền Phượng Hoàng (Đại Sảnh Danh Vọng)");
    L.put("map.is94",    "Tiền Đồn Hoàng Hôn (Chiến Trường)");
    L.put("map.is95",    "Địa Ngục Băng (LA)");
    L.put("map.is96",    "Đấu Trường Thần (Doosan)");
    L.put("map.is97",    "Đền Hoàng Hôn Tái Bản");
    L.put("map.is98",    "Đào Viên (Mentoring)");
    L.put("map.is99",    "Cõi Mộng");
    L.put("map.is101",   "Đèo Sói Trắng");
    L.put("map.is102",   "Chiến Trường Hoàng Gia");
    L.put("map.is103",   "Vùng Đất Phía Bắc");
    L.put("map.is105",   "Bàn Thờ Trinh Nữ");
    L.put("map.is106",   "Chiến Trường Hoàng Gia");
    L.put("map.is107",   "Vùng Đất Phía Bắc");
    L.put("map.is108",   "Đình Trăng Tròn");
    L.put("map.is109",   "Cõi Biến Hóa");
    L.put("map.bg01",    "Chiến Tranh Lãnh Thổ T-3 PvP");
    L.put("map.bg02",    "Chiến Tranh Lãnh Thổ T-3 PvE");
    L.put("map.bg03",    "Chiến Tranh Lãnh Thổ T-2 PvP");
    L.put("map.bg04",    "Chiến Tranh Lãnh Thổ T-2 PvE");
    L.put("map.bg05",    "Chiến Tranh Lãnh Thổ T-1 PvP");
    L.put("map.bg06",    "Chiến Tranh Lãnh Thổ T-1 PvE");
    L.put("map.arena01", "Đấu Trường Etherblade");
    L.put("map.arena02", "Đấu Trường Lost");
    L.put("map.arena03", "Đấu Trường Plume");
    L.put("map.arena04", "Đấu Trường Archosaur");
    L.put("map.rand03",  "Mê Cung Cát Lún (Ảo Ảnh Bão Cát)");
    L.put("map.rand04",  "Mê Cung Cát Lún (Ảo Ảnh Cát Lang Thang)");
    L.put("map.rand05",  "Lăng Mộ Thì Thầm");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║              QUẢN LÝ TÀI KHOẢN (ACCOUNT)                   ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("acct.login_required",      "Đăng nhập để Quản lý Tài khoản...");
    L.put("acct.registration",        "Đăng ký Tài khoản");
    L.put("acct.change_password",     "Đổi Mật khẩu");
    L.put("acct.delete_account",      "Xóa Tài khoản");
    L.put("acct.gm_management",       "Quản lý Game Master");
    L.put("acct.cubi_transfer",       "Chuyển Cubi");
    L.put("acct.browse_accounts",     "Danh sách Tài khoản");
    L.put("acct.login_label",         "Tên đăng nhập");
    L.put("acct.password_label",      "Mật khẩu");
    L.put("acct.email_label",         "E-Mail");
    L.put("acct.old_password",        "Mật khẩu cũ");
    L.put("acct.new_password",        "Mật khẩu mới");
    L.put("acct.type_label",          "Loại");
    L.put("acct.type_by_id",          "theo ID");
    L.put("acct.type_by_login",       "theo Tên đăng nhập");
    L.put("acct.identifier",          "Định danh");
    L.put("acct.characters_label",    "Nhân vật");
    L.put("acct.characters_keep",     "Giữ Nhân vật");
    L.put("acct.action_label",        "Hành động");
    L.put("acct.grant_gm",            "Cấp GM");
    L.put("acct.deny_gm",             "Thu hồi GM");
    L.put("acct.amount_label",        "Số lượng");
    L.put("acct.btn.register",        "Đăng ký");
    L.put("acct.btn.change_pass",     "Đổi Mật khẩu");
    L.put("acct.btn.delete",          "Xóa Tài khoản");
    L.put("acct.btn.submit",          "Thực hiện");
    L.put("acct.btn.transfer",        "Chuyển Cubi");
    L.put("acct.table.id",            "ID");
    L.put("acct.table.name",          "Tên");
    L.put("acct.table.creation",      "Ngày tạo");
    L.put("acct.msg.only_4_10",       "Chỉ chấp nhận 4-10 Ký tự");
    L.put("acct.msg.forbidden_chars", "Ký tự không hợp lệ");
    L.put("acct.msg.user_exists",     "Người dùng Đã Tồn Tại");
    L.put("acct.msg.account_created", "Tài khoản Đã Được Tạo");
    L.put("acct.msg.user_not_exist",  "Người dùng Không Tồn Tại");
    L.put("acct.msg.old_pass_wrong",  "Mật khẩu Cũ Không Đúng");
    L.put("acct.msg.password_changed","Mật khẩu Đã Được Đổi");
    L.put("acct.msg.access_denied",   "Truy cập Bị Từ chối");
    L.put("acct.msg.account_deleted", "Tài khoản Đã Xóa");
    L.put("acct.msg.check_chars",     "Vui lòng Kiểm tra Nhân vật Còn Tồn Tại (ID %s - %s)");
    L.put("acct.msg.gm_removed",      "Đã Thu hồi Quyền GM");
    L.put("acct.msg.already_gm",      "Người dùng Đã Có Quyền GM");
    L.put("acct.msg.gm_added",        "Đã Cấp Quyền GM Cho Người dùng");
    L.put("acct.msg.not_gm",          "Người dùng Không Có Quyền GM");
    L.put("acct.msg.invalid_amount",  "Số lượng Không Hợp Lệ (1-999999)");
    L.put("acct.msg.cubi_added",      "%.2f Cubi Gold Đã Được Thêm");
    L.put("acct.msg.cubi_note",       "Giao dịch Có Thể Mất Đến 5 Phút. Cần Thoát Game Và Đăng Nhập Lại Để Nhận Cubi.");
    L.put("acct.msg.db_failed",       "Kết Nối Đến Cơ Sở Dữ Liệu MySQL Thất Bại");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║                CẤU HÌNH SERVER (SERVER)                     ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("server.login_required",    "Đăng nhập để Cấu hình Server...");
    L.put("server.title",             "Trình Chỉnh Sửa Tỉ Lệ Server");
    L.put("server.version_label",     "Phiên bản:");
    L.put("server.exp_rate",          "Tỉ lệ EXP");
    L.put("server.sp_rate",           "Tỉ lệ SP");
    L.put("server.drop_rate",         "Tỉ lệ Rơi Đồ");
    L.put("server.coins_rate",        "Tỉ lệ Tiền");
    L.put("server.task_exp_rate",     "Tỉ lệ EXP Nhiệm vụ");
    L.put("server.task_sp_rate",      "Tỉ lệ SP Nhiệm vụ");
    L.put("server.task_coins_rate",   "Tỉ lệ Tiền Nhiệm vụ");
    L.put("server.base_value",        "Giá trị Gốc: 0");
    L.put("server.btn.save",          "Lưu Tỉ lệ");
    L.put("server.confirm_save",      "Trang này không dành cho phiên bản dưới 173. Bạn có chắc không?");
    L.put("server.msg.saved",         "Đã Lưu Tỉ lệ! Vui lòng tải lại trang và khởi động lại server để thay đổi có hiệu lực.");
    L.put("server.msg.save_error",    "Lỗi khi lưu tỉ lệ: %s");
    L.put("server.msg.read_error",    "Lỗi đọc file: %s");
    L.put("server.trace_log",         "Nhật ký Gỡ lỗi");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║                   CÀI ĐẶT (SETTINGS)                       ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("settings.tab.general",     "Chung");
    L.put("settings.tab.whitelist",   "Whitelist");
    L.put("settings.tab.create_gm",   "Tạo Tài khoản");
    L.put("settings.tab.backups",     "Sao lưu");
    L.put("settings.enable_ip_wl",    "Bật IP Whitelist:");
    L.put("settings.enable_addons",   "Bật Tab Addons:");
    L.put("settings.enable_charlist", "Bật Danh sách Nhân vật:");
    L.put("settings.btn.save",        "Lưu Cài đặt");
    L.put("settings.msg.updated",     "Đã Cập nhật Cài đặt.");
    L.put("settings.msg.no_file",     "File cấu hình không tồn tại!");
    L.put("settings.msg.error",       "Lỗi: %s");
    L.put("settings.wl.add_ip",       "Thêm IP vào Whitelist");
    L.put("settings.wl.ip_placeholder","Nhập địa chỉ IP hợp lệ (VD: 127.0.0.1)");
    L.put("settings.wl.table.ip",     "Địa chỉ IP");
    L.put("settings.wl.table.delete", "Xóa");
    L.put("settings.wl.btn.update",   "Cập nhật Whitelist");
    L.put("settings.wl.msg.updated",  "Đã cập nhật Whitelist. Vui lòng tải lại trang để thấy thay đổi!");
    L.put("settings.wl.msg.invalid",  "Địa chỉ IP không hợp lệ: ");
    L.put("settings.gm.current_users","Người dùng Hiện tại");
    L.put("settings.gm.btn.delete",   "Xóa Người dùng Đã Chọn");
    L.put("settings.gm.username",     "Tên đăng nhập:");
    L.put("settings.gm.password",     "Mật khẩu:");
    L.put("settings.gm.allow_settings","Cho phép Truy cập Cài đặt");
    L.put("settings.gm.allow_whitelist","Cho phép Truy cập Whitelist");
    L.put("settings.gm.allow_account", "Cho phép Truy cập Tài khoản");
    L.put("settings.gm.allow_role",    "Cho phép Truy cập Nhân vật");
    L.put("settings.gm.allow_server",  "Cho phép Truy cập Cấu hình Server");
    L.put("settings.gm.allow_sctrl",   "Cho phép Truy cập Điều khiển Server");
    L.put("settings.gm.btn.create",    "Tạo Người dùng");
    L.put("settings.gm.msg.created",   "Đã tạo người dùng GM thành công.");
    L.put("settings.gm.msg.deleted",   "Đã xóa người dùng GM thành công.");
    L.put("settings.gm.msg.table_created","Đã tạo bảng 'gmpanel_users' thành công.");
    L.put("settings.gm.msg.db_error",  "Lỗi cơ sở dữ liệu: %s");
    L.put("settings.gm.msg.store_error","Lỗi lưu thông tin: %s");
    L.put("settings.backup.title",     "Cài đặt Sao lưu");
    L.put("settings.backup.full",      "Sao lưu Toàn bộ (%s)");
    L.put("settings.backup.db",        "Sao lưu Cơ sở dữ liệu (%s)");
    L.put("settings.backup.select",    "Chọn Thư mục để Sao lưu");
    L.put("settings.backup.local_path","Đường dẫn Sao lưu Cục bộ:");
    L.put("settings.backup.path_placeholder","đường/dẫn/đến/thư/mục/sao/lưu");
    L.put("settings.backup.btn.create","Tạo Sao lưu Cục bộ");
    L.put("settings.backup.msg.no_path","Vui lòng chỉ định đường dẫn sao lưu cục bộ.");
    L.put("settings.backup.msg.no_srv_path","Thư mục server chưa được định nghĩa trong file cài đặt.");
    L.put("settings.backup.msg.created","Đã tạo sao lưu cục bộ tại: ");
    L.put("settings.backup.msg.db_created","Đã tạo sao lưu cơ sở dữ liệu tại: ");
    L.put("settings.backup.msg.error_local","Lỗi khi sao lưu cục bộ: ");
    L.put("settings.backup.msg.error_db","Lỗi khi sao lưu cơ sở dữ liệu: ");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║                DANH SÁCH NHÂN VẬT (ROLE)                   ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("role.login_required",      "Đăng nhập để Quản lý Nhân vật...");
    L.put("role.title",               "Danh sách Người chơi");
    L.put("role.table.id",            "ID");
    L.put("role.table.name",          "Tên");
    L.put("role.table.class",         "Lớp");
    L.put("role.table.level",         "Cấp");
    L.put("role.table.action",        "Hành động");
    L.put("role.btn.view_xml",        "Xem XML");
    L.put("role.btn.view_gui",        "Xem GUI");
    L.put("role.pagination.prev",     "Trước");
    L.put("role.pagination.next",     "Sau");
    L.put("role.no_players",          "Không tìm thấy người chơi nào có ID lớn hơn 1000.");
    L.put("role.invalid_data",        "Định dạng dữ liệu không hợp lệ");
    L.put("role.process_error",       "Tiến trình thoát với lỗi");
    L.put("role.msg.error",           "Lỗi");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║                     TÊN LỚP NHÂN VẬT                        ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("class.0",  "Blademaster");
    L.put("class.1",  "Wizard");
    L.put("class.2",  "Psychic");
    L.put("class.3",  "Venomancer");
    L.put("class.4",  "Barbarian");
    L.put("class.5",  "Assassin");
    L.put("class.6",  "Archer");
    L.put("class.7",  "Cleric");
    L.put("class.8",  "Seeker");
    L.put("class.9",  "Mystic");
    L.put("class.10", "Duskblade");
    L.put("class.11", "Stormbringer");
    L.put("class.14", "Wildwalker");
    L.put("class.unknown", "Không rõ");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║                   TRUY CẬP BỊ TỪ CHỐI                      ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("denied.title",    "Truy cập Bị Từ chối");
    L.put("denied.subtitle", "IP của bạn (%s) không có trong danh sách cho phép (whitelist).");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║                   ADDONS - TRANG CHÍNH                      ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("addons.title",             "DANH SÁCH PLUGIN");
    L.put("addons.subtitle",          "Danh sách plugin đã cài đặt");
    L.put("addons.plugins",           "Plugins");
    L.put("addons.search_plugins",    "+ Tìm Plugin +");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║              ADDONS - GM CONTROL (Quản lý GM)              ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("gmctrl.title",             "Quản lý GameMaster");
    L.put("gmctrl.subtitle",          "Quản lý tài khoản GM và nhân vật");
    L.put("gmctrl.login_required",    "Đăng nhập để sử dụng Quản lý GM...");
    L.put("gmctrl.gm_list",           "Danh sách Game Master");
    L.put("gmctrl.account_char",      "Tài khoản / Nhân vật");
    L.put("gmctrl.occupation",        "Lớp");
    L.put("gmctrl.level",             "Cấp");
    L.put("gmctrl.remove_gm",         "Thu hồi GM");
    L.put("gmctrl.permissions",       "Phân quyền");
    L.put("gmctrl.db_failed",         "Kết nối đến cơ sở dữ liệu MySQL thất bại");
    L.put("gmctrl.perm_editor",       "Trình chỉnh sửa phân quyền");
    L.put("gmctrl.perm_subtitle",     "Quản lý quyền hạn GM");
    L.put("gmctrl.perm_full",         "Quản lý quyền hạn GM (Đầy đủ)");
    L.put("gmctrl.perm_for_acct",     "Phân quyền tài khoản: %d");
    L.put("gmctrl.enable_all",        "Bật tất cả");
    L.put("gmctrl.disable_all",       "Tắt tất cả");
    L.put("gmctrl.description",       "Mô tả");
    L.put("gmctrl.cmd_id",            "cmd ID");
    L.put("gmctrl.allowed",           "Cho phép");
    L.put("gmctrl.always",            "luôn có");
    L.put("gmctrl.save",              "Lưu");
    L.put("gmctrl.back",              "Quay lại");
    L.put("gmctrl.no_search",         "Không có tham số tìm kiếm...");
    L.put("gmctrl.perm_applied",      "Đã áp dụng phân quyền, bạn có thể cần khởi động lại authd để thay đổi có hiệu lực.");
    // GM Permission descriptions
    L.put("gmctrl.perm.gm_tag",               "Thẻ GM");
    L.put("gmctrl.perm.create_object",        "Tạo vật phẩm");
    L.put("gmctrl.perm.switch_name_id",       "Đổi tên và ID người chơi");
    L.put("gmctrl.perm.hidden_invincible",    "Trạng thái ẩn hoặc bất tử");
    L.put("gmctrl.perm.switch_online",        "Chuyển trạng thái online");
    L.put("gmctrl.perm.hide_online",          "Ẩn trạng thái online khỏi chat");
    L.put("gmctrl.perm.teleport_to_player",   "Dịch chuyển đến người chơi");
    L.put("gmctrl.perm.teleport_player_to_gm","Dịch chuyển người chơi đến GM");
    L.put("gmctrl.perm.teleport_ctrl_click",  "Dịch chuyển bằng ctrl+click bản đồ");
    L.put("gmctrl.perm.show_online",          "Hiển thị số người online");
    L.put("gmctrl.perm.ban_player",           "Cấm tài khoản/nhân vật");
    L.put("gmctrl.perm.mute_player",          "Khóa chat tài khoản/nhân vật");
    L.put("gmctrl.perm.ban_trading",          "Cấm giao dịch");
    L.put("gmctrl.perm.ban_selling",          "Cấm bán hàng");
    L.put("gmctrl.perm.gm_broadcast",         "Thông báo toàn server (GM)");
    L.put("gmctrl.perm.restart_gameserver",   "Khởi động lại gameserver");
    L.put("gmctrl.perm.create_monster",       "Tạo quái vật");
    L.put("gmctrl.perm.activate_monster",     "Kích hoạt Trình tạo quái");
    L.put("gmctrl.show_non_impl",             "Hiển thị Tính năng Chưa triển khai");
    // Useless features
    L.put("gmctrl.perm.move_to_npc",          "Di chuyển đến NPC (vô dụng)");
    L.put("gmctrl.perm.move_to_map",          "Di chuyển đến Bản đồ (vô dụng)");
    L.put("gmctrl.perm.increase_speed",       "Tăng Tốc độ (vô dụng)");
    L.put("gmctrl.perm.follow_player",        "Đi theo Người chơi (vô dụng)");
    L.put("gmctrl.perm.delete_monster",       "Xóa Quái vật (vô dụng)");
    L.put("gmctrl.perm.morph_monster",        "Biến thành Quái vật (vô dụng)");
    L.put("gmctrl.perm.gm_admin",             "Quản trị GM (vô dụng)");
    L.put("gmctrl.perm.set_double_exp",       "Đặt gấp đôi EXP (vô dụng)");
    L.put("gmctrl.perm.set_ip_limit",         "Đặt giới hạn kết nối cùng IP (vô dụng)");
    L.put("gmctrl.perm.forbid_trade_all",     "Cấm giao dịch tất cả (vô dụng)");
    L.put("gmctrl.perm.forbid_auction_all",   "Cấm đấu giá tất cả (vô dụng)");
    L.put("gmctrl.perm.forbid_mail_all",      "Cấm thư trong game tất cả (vô dụng)");
    L.put("gmctrl.perm.forbid_faction_all",   "Cấm hoạt động Bang hội (vô dụng)");
    L.put("gmctrl.perm.set_double_money",     "Đặt gấp đôi tiền rơi (vô dụng)");
    L.put("gmctrl.perm.set_double_item",      "Đặt gấp đôi đồ rơi (vô dụng)");
    L.put("gmctrl.perm.set_double_sp",        "Đặt gấp đôi SP (vô dụng)");
    L.put("gmctrl.perm.forbid_point_card",    "Cấm bán thẻ điểm (vô dụng)");
    L.put("gmctrl.perm.edit_char_data",       "Sửa dữ liệu nhân vật (vô dụng)");
    L.put("gmctrl.perm.check_server_status",  "Kiểm tra trạng thái server (vô dụng)");
    L.put("gmctrl.perm.check_log",            "Kiểm tra nhật ký (vô dụng)");
    L.put("gmctrl.perm.reboot_gameserver",    "Khởi động lại gameserver cưỡng chế (vô dụng)");
    L.put("gmctrl.perm.reboot_db",            "Khởi động lại database cưỡng chế (vô dụng)");
    L.put("gmctrl.perm.find_char_id",         "Tìm ID từ tên nhân vật (vô dụng)");
    L.put("gmctrl.perm.view_char_data",       "Xem dữ liệu nhân vật (vô dụng)");
    L.put("gmctrl.perm.char_online_status",   "Trạng thái online nhân vật (vô dụng)");
    L.put("gmctrl.perm.send_item_mail",       "Gửi thư kèm vật phẩm (vô dụng)");
    L.put("gmctrl.perm.see_ban_history",      "Xem lịch sử cấm (vô dụng)");
    L.put("gmctrl.perm.see_cubi_payments",    "Xem giao dịch cubigold (vô dụng)");
    L.put("gmctrl.perm.see_cubi_amount",      "Xem số lượng cubigold (vô dụng)");
    L.put("gmctrl.perm.add_cubigold",         "Thêm cubigold (vô dụng)");
    L.put("gmctrl.perm.view_by_username",     "Xem theo tên đăng nhập (vô dụng)");
    L.put("gmctrl.perm.edit_username",        "Sửa tên đăng nhập (vô dụng)");
    L.put("gmctrl.perm.remove_ban",           "Gỡ cấm (vô dụng)");
    L.put("gmctrl.perm.get_role_list",        "Lấy danh sách nhân vật (vô dụng)");
    L.put("gmctrl.perm.change_password",      "Đổi mật khẩu (vô dụng)");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║           ADDONS - LIST GM ACCOUNTS (DS TK GM)             ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("gmlist.title",             "Tài khoản GM");
    L.put("gmlist.subtitle",          "Danh sách tài khoản GameMaster");
    L.put("gmlist.id",                "ID");
    L.put("gmlist.name",              "Tên");
    L.put("gmlist.creation_time",     "Ngày tạo");
    L.put("gmlist.error",             "Lỗi: %s");
    L.put("gmlist.error_closing",     "Lỗi khi đóng: %s");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║              ADDONS - IP LOG (Nhật ký IP)                  ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("iplog.title",              "Nhật ký IP");
    L.put("iplog.subtitle",           "Lịch sử đăng nhập Admin Panel");
    L.put("iplog.time",               "Thời gian");
    L.put("iplog.ip",                 "IP");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║          ADDONS - SPOUSE MANAGER (Quản lý Hôn nhân)        ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("spouse.title",             "QUẢN LÝ HÔN NHÂN");
    L.put("spouse.subtitle",          "Quản lý hôn nhân nhân vật");
    L.put("spouse.marry",             "Kết hôn");
    L.put("spouse.groom",             "Chú rể");
    L.put("spouse.bride",             "Cô dâu");
    L.put("spouse.marry_btn",         "Kết hôn");
    L.put("spouse.divorce",           "Ly hôn");
    L.put("spouse.char_name",         "Tên nhân vật");
    L.put("spouse.divorce_btn",       "Ly hôn");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║              ADDONS - SEND MAIL (Gửi Thư)                  ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("sendmail.title",           "GỬI THƯ");
    L.put("sendmail.subtitle",        "Gửi thư và vật phẩm cho người chơi");
    L.put("sendmail.manual",          "Hướng dẫn");
    L.put("sendmail.send_btn",        "Gửi Thư");
    L.put("sendmail.back",            "Quay lại");
    L.put("sendmail.title2",          "GỬI THƯ 2");
    L.put("sendmail.subtitle2",       "Gửi thư bằng cách nhập thông tin vật phẩm thủ công");
    L.put("sendmail.title3",          "GỬI THƯ 3");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║              ADDONS - GS FIX (Sửa GS)                      ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("gsfix.title",              "Chạy gsfix.sh");
    L.put("gsfix.subtitle",           "GS Fix Script");
    L.put("gsfix.run_btn",            "Chạy Script");
    L.put("gsfix.error_no_path",      "Lỗi: Đường dẫn GS trống. Vui lòng cung cấp đường dẫn!");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║            ADDONS - PANEL CHAT (Chat Panel)                ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("chat.title",               "Panel Chat");
    L.put("chat.subtitle",            "Hệ thống chat thời gian thực");
    L.put("chat.set_name",            "Đặt Tên Của Bạn");
    L.put("chat.set_name_btn",        "Đặt Tên");
    L.put("chat.send_btn",            "Gửi");
    L.put("chat.clear_btn",           "Xóa Chat");
    L.put("chat.edit_name_btn",       "Sửa Tên");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║            ADDONS - CHANGE PASSWORD (Đổi MK)               ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("changepw.title",           "ĐỔI MẬT KHẨU CƯỠNG CHẾ");
    L.put("changepw.subtitle",        "Đổi mật khẩu tài khoản người chơi");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║            ADDONS - GUILD ICON (Icon Bang)                 ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("guildicon.login_btn",      "Đăng nhập");
    L.put("guildicon.logout_btn",     "Đăng xuất");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║            ADDONS - LIVE CHAT (Chat trực tuyến)            ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("livechat.title",           "LIVE CHAT");
    L.put("livechat.subtitle",        "Hệ thống chat trực tuyến");
    L.put("livechat.login_required",  "Đăng nhập để sử dụng Live Chat...");
    L.put("livechat.send_btn",        "Gửi");
    L.put("livechat.clear_btn",       "Xóa Chat");
    L.put("livechat.cleared",         "Đã xóa file nhật ký chat");
    L.put("livechat.clear_failed",    "Xóa file nhật ký chat thất bại");
    L.put("livechat.sent",            "Đã gửi tin nhắn");
    L.put("livechat.send_failed",     "Gửi tin nhắn thất bại");
    L.put("livechat.append_failed",   "Ghi vào file nhật ký thất bại");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║          ADDONS - GUILD ICON (Icon Bang hội)              ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("guildicon.title",          "Quản lý Icon Bang Hội");
    L.put("guildicon.subtitle",       "Tải lên và quản lý icon bang hội");
    L.put("guildicon.root_access",    "Root Access: ");
    L.put("guildicon.download_btn",   "Tải xuống");
    L.put("guildicon.faction_leader", "Bang hội (Bang chủ):");
    L.put("guildicon.current_icon",   "Icon Hiện tại:");
    L.put("guildicon.reset_icon",     "Xóa Icon:");
    L.put("guildicon.reset_hint",     "Tích để xóa icon hiện tại");
    L.put("guildicon.commit_icon",    "Tải lên Icon:");
    L.put("guildicon.submit_btn",     "Xác nhận");
    L.put("guildicon.icon_removed",   "Đã xóa Icon");
    L.put("guildicon.remove_failed",  "Xóa Icon thất bại!");
    L.put("guildicon.icon_committed", "Đã cập nhật Icon");
    L.put("guildicon.required_gif",   "Yêu cầu ảnh GIF 16x16!");
    L.put("guildicon.no_permission",  "Không có quyền thực hiện!");
    L.put("guildicon.faction_not_found","Không tìm thấy Bang hội!");
    L.put("guildicon.no_factions",    "Không tìm thấy Bang hội nào");
    L.put("guildicon.error_get_dir",  "Lỗi khi đọc thư mục icons!");
    L.put("guildicon.error_parse",    "Lỗi phân tích dữ liệu form!");
    L.put("guildicon.debug_log",      "Nhật ký Gỡ lỗi");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║            ADDONS - VERSION INFO (Thông tin phiên bản)     ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("version.title",            "Thông tin Phiên bản");
    L.put("version.text",             "Remix Version 4<br>Phiên bản này bởi Crucifix, Creez, Krona và corzca dựa trên pwAdmin của DaMadBoy, Sora1984, Bola.");

    // ╔══════════════════════════════════════════════════════════════╗
    // ║            ADDONS - SKILL HEXGEN                           ║
    // ╚══════════════════════════════════════════════════════════════╝
    L.put("skillhex.title",           "Skill HexGen");
    L.put("skillhex.allclass",        "Kỹ năng Chung");
    L.put("skillhex.unavailable",     "chưa có");
    L.put("skillhex.submit_btn",      "Tạo XML");
    L.put("skillhex.basic",           "Cơ bản");
    L.put("skillhex.short_edge",      "Đoản kiếm");
    L.put("skillhex.polearm",         "Trường thương");
    L.put("skillhex.blunt",           "Đốn độn");
    L.put("skillhex.fist",            "Quyền sáo");
    L.put("skillhex.all",             "Tất cả");
    L.put("skillhex.misc_passive",    "Khác / Bị động");
    L.put("skillhex.fire",            "Hỏa");
    L.put("skillhex.water",           "Thủy");
    L.put("skillhex.earth",           "Thổ");
    L.put("skillhex.human_form",      "Hình người");
    L.put("skillhex.tiger_form",      "Hổ");
    L.put("skillhex.bless",           "Phù phép");
    L.put("skillhex.wood",            "Mộc");
    L.put("skillhex.fox_form",        "Cáo");
    L.put("skillhex.pet",             "Pet");
    L.put("skillhex.gen_skill_xml",   "Tạo XML Kỹ năng");

    }

    // ╔══════════════════════════════════════════════════════════════╗
    // ║                   HÀM TIỆN ÍCH                              ║
    // ╚══════════════════════════════════════════════════════════════╝

    /**
     * Lấy chuỗi tiếng Việt từ key. Nếu key không tồn tại, trả về key gốc
     * để tránh lỗi NullPointerException và dễ phát hiện key thiếu.
     *
     * Cách dùng trong JSP: gọi T("key") hoặc Tf("key", arg1, arg2).
     */
    String T(String key) {
        String val = L.get(key);
        return val != null ? val : "???" + key + "???";
    }

    /**
     * Lấy chuỗi có định dạng (String.format)
     * Cách dùng trong JSP: gọi Tf("key", arg1).
     */
    String Tf(String key, Object... args) {
        String val = L.get(key);
        if (val == null) return "???" + key + "???";
        try {
            return String.format(val, args);
        } catch (Exception e) {
            return val;
        }
    }
%>