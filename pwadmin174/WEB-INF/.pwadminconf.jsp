<%@page import="java.io.*"%>
<%@page import="java.util.Properties"%>
<%
//-------------------------------------------------------------------------------------------------------------------------
//------------------------------- SETTINGS --------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------
    // Enable or disable the IP whitelist. Set to true to enable, false to disable.
    //boolean enable_ip_whitelist = true;
    boolean enable_ip_whitelist = true;


	// connection settings to the mysql pw database
	String db_host = "localhost";
	String db_port = "3306";
	String db_user = "root";
	String db_password = "root";
	String db_database = "pw";

	// Type of your items database required for mapping id's to names
	// Options are my or pwi
	String item_labels = "pwi";

	// Absolute path to your PW-Server main directory (startscript, stopscript, /gamed)
	// requires a tailing slash
	String pw_server_path = "/home/";
	// not requires a tailing slash
	String pw_admin_path = "/root/pwadmin174/webapps/pwadmin";

	// If you have hundreds of characters or heavy web acces through this site
	// It is recommend to turn the realtime character list feature off (false)
	// to prevent server from overload injected by character list generation
	boolean enable_character_list = true;

	String pw_server_name = "Perfect World 174";
	String pw_server_description = "Fixed by DaMadBoy, 151 iweb from Bola, Merged by Sora1984";

	// Enable or disable the iptables tab. Set to true to enable, false to disable.
    //boolean enable_iptables_tab = true;
    boolean enable_iptables_tab = false;

    // Enable or disable the addons tab. Set to true to enable, false to disable.
    boolean enable_addons_tab = true;


    // Load settings from file (if available)
    Properties settings = new Properties();
    FileInputStream fis = null;
    File configFile = new File(application.getRealPath("WEB-INF/.pwadminconf.properties"));
    if(configFile.exists()) {
        try {
             fis = new FileInputStream(configFile);
            settings.load(fis);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (fis != null) {
                try {
                    fis.close();
                } catch (IOException e) {
                   e.printStackTrace();
                }
            }
        }
    }

   //Override values if properties are set in the file
    if(settings.containsKey("enable_ip_whitelist"))
    	enable_ip_whitelist = Boolean.parseBoolean(settings.getProperty("enable_ip_whitelist"));
    if(settings.containsKey("enable_iptables_tab"))
        enable_iptables_tab = Boolean.parseBoolean(settings.getProperty("enable_iptables_tab"));
    if(settings.containsKey("enable_addons_tab"))
        enable_addons_tab = Boolean.parseBoolean(settings.getProperty("enable_addons_tab"));
//-------------------------------------------------------------------------------------------------------------------------
//----------------------------- END SETTINGS ------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------

	String pw_server_exp = "?";
	String pw_server_sp = "?";
	String pw_server_drop = "?";
	String pw_server_coins = "?";

	BufferedReader bfr = new BufferedReader(new FileReader(pw_server_path + "gamed/ptemplate.conf"));

	String row;
	while((row = bfr.readLine()) != null)
	{
		row = row.replaceAll("\\s", "");
		if(row.indexOf("exp_bonus=") != -1)
		{
			int pos = row.length();
			if(row.indexOf("#") != -1)
			{
				pos = row.indexOf("#");
			}
			pw_server_exp = row.substring(10, pos);
		}
		if(row.indexOf("sp_bonus=") != -1)
		{
			int pos = row.length();
			if(row.indexOf("#") != -1)
			{
				pos = row.indexOf("#");
			}
			pw_server_sp = row.substring(9, pos);
		}
		if(row.indexOf("drop_bonus=") != -1)
		{
			int pos = row.length();
			if(row.indexOf("#") != -1)
			{
				pos = row.indexOf("#");
			}
			pw_server_drop = row.substring(11, pos);
		}
		if(row.indexOf("money_bonus=") != -1)
		{
			int pos = row.length();
			if(row.indexOf("#") != -1)
			{
				pos = row.indexOf("#");
			}
			pw_server_coins = row.substring(12, pos);
		}
	}

	bfr.close();

	if(request.getSession().getAttribute("items") == null)
	{
		String[] items = new String[30001];

		try
		{
			bfr = new BufferedReader(new InputStreamReader(new FileInputStream(new File(application.getRealPath("/include/items") + "/default.dat")), "UTF8"));
			if(item_labels.compareTo("my") == 0)
			{
				bfr = new BufferedReader(new InputStreamReader(new FileInputStream(new File(application.getRealPath("/include/items") + "/my.dat")), "UTF8"));
			}
			if(item_labels.compareTo("pwi") == 0)
			{
				bfr = new BufferedReader(new InputStreamReader(new FileInputStream(new File(application.getRealPath("/include/items") + "/pwi.dat")), "UTF8"));
			}
			int count = 0;
			while((row = bfr.readLine()) != null && count < 30001)
			{
				items[count] = row;
				count++;
			}
			bfr.close();
		}
		catch(Exception e)
		{
		}

		request.getSession().setAttribute("items", items);
	}
%>