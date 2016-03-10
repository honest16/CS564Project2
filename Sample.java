import java.util.*;
import java.io.*;
import java.sql.*;

public class Sample {
	public static void main(String args[]) {
		Scanner in = new Scanner(System.in);
		Random rng = new Random();
		Connection c = null;
		String command, previousCommand, url, username;
		int seed = 0;
		boolean redoingCommand = false;
		
		url = "jdbc:postgresql://stampy.cs.wisc.edu/cs564instr?sslfactory=org.postgresql.ssl.NonValidatingFactory&ssl";
		username = "";
		previousCommand = "";
		command = "";
		
		//print out some helpful information like commands and help menu
		
		do {
			if(!redoingCommand) System.out.print(username + "> ");
			if(!command.equals("")) previousCommand = command;
			if(!redoingCommand) command = in.nextLine();
			redoingCommand = false;
			switch(command.split(" ")[0]) {
					case "seed":
						//make sure they passed in a number for the seed
						try {
							seed = Integer.parseInt(command.split(" ")[1]);
							rng = new Random(seed);
							System.out.println("Seed set to " + seed);
						} catch (NumberFormatException e) {
							System.out.println(command.split(" ")[1] + " is not a valid seed");
							System.out.println("Usage: > seed <seed value>");
						}
						break;
					case "sample":
						String query = "";
						String table = "";
						int numSamples = 0;
						int numRecords = 0;
						
						if(c == null) {
							System.out.println("Error: connect to a database first. Use the connect command.");
							break;
						}
						
						if(command.split(" ").length > 1) {
							try {
								numSamples = Integer.parseInt(command.split(" ")[1]);
							} catch(NumberFormatException e) {
								System.out.println("Error: input integer number of samples");
								System.out.println("Usage: > sample <number> <table or query>");
								break;
							}
						}
						
						if(command.split(" ").length == 3) {
							table = command.split(" ")[2];
							numRecords = getNumRecordsFromTable(table, c);
							if(numRecords < 0) break;
							
							int numConsidered = 0;
							int numSelected = 0;
							
							boolean printAll = numRecords < numSamples;
							numSamples = Math.min(numRecords, numSamples);
							
							while(numSelected < numSamples) {
								if((numRecords - numConsidered) * rng.nextFloat() < numSamples - numSelected) {
									//include the (numConsidered + 1)st record. Slightly different than in the project spec
									
									try {
										Statement stmt = c.createStatement();
										ResultSet rs = stmt.executeQuery("select * from (select ROW_NUMBER() over (order by weekdate) as rownum, * from " + table + ") as tbl where tbl.rownum = " + (numConsidered + 1) + ";");
										ResultSetMetaData rsmd = rs.getMetaData();
										ArrayList<String> cols = new ArrayList<String>();
										for(int i = 1; i <= rsmd.getColumnCount(); i++) {
											if(!rsmd.getColumnName(i).equals("rownum")) cols.add(rsmd.getColumnName(i));
										}
										while(rs.next()) {
											for(int i = 0; i < cols.size(); i++) {
												String seperator = "";
												if(i < cols.size() - 1) seperator = " | ";
												System.out.print(rs.getString(cols.get(i)) + seperator);
											}
											System.out.println();
										}
										rs.close();
										stmt.close();
										
									} catch(SQLException e) {
										System.out.println("Error: cannot process sample query");
										e.printStackTrace();
									}
									numSelected++;
								}
								numConsidered++;
							}
							
							if(printAll) {
								System.out.println("Note: All records of table " + table + " were returned.");
							}
							
							
							
						} else if(command.split(" ").length > 3) {
							StringBuilder strBuilder = new StringBuilder();
							for(int i = 2; i < command.split(" ").length; i++) {
								strBuilder.append(command.split(" ")[i] + " ");
							}
							query = strBuilder.toString().trim();
						} else {
							System.out.println("Usage: > sample <number> <table or query>");
						}
						/*
						try {
							Statement stmt = c.createStatement();
							ResultSet rs = stmt.executeQuery("select * from (select ROW_NUMBER() OVER (order by weekdate) as \"RowNum\", * from " + query + " as tbl where tbl.\"RowNum\" = " + numSamples + ";");
							while(rs.next()) {
								String weekdate = rs.getString("weekdate");
								boolean isHoliday = rs.getBoolean("isHoliday");
								
								System.out.println(weekdate + " | " +isHoliday);
							}
							rs.close();
							stmt.close();
							
						} catch(SQLException e) {
							System.out.println("Error: cannot process sample query");
							e.printStackTrace();
						}
						*/
						break;
					case "connect":
						String password;
						String className = "org.postgresql.Driver";
						try {
							Class.forName(className);
						} catch (ClassNotFoundException e) {
							System.out.println("Error: Class name " + className + " not found");
						}
						
						if(command.split(" ").length == 4) {
							url = command.split(" ")[1];
							username = command.split(" ")[2];
							password = command.split(" ")[3];
						} else if(command.split(" ").length == 3) {
							//use default url if none provided
							username = command.split(" ")[1];
							password = command.split(" ")[2];
							try {
								c = DriverManager.getConnection(url, username, password);
							} catch(SQLException e) {
								System.out.println("Error: Cannot get connection to " + url);
								username = "";
								e.printStackTrace();
							}	
						}					
						
						break;
					case "exit": 
						try {
							if(c != null) c.close();
						} catch (SQLException e) {
							System.out.println("Error: unable to close connection");
						}
						System.exit(1);
						break;
					case "\t":
						redoingCommand = true;
						command = previousCommand;
						break;
					case "help":
						System.out.println("\n------ helpful information ------");
						System.out.println("url  = " + url);
						System.out.println("user = " + username);
						System.out.println("seed = " + seed);
						System.out.println("last command = " + previousCommand);
						System.out.println("\n------ commands ------");
						System.out.println("seed <seed value>");
						System.out.println("connect [url] <username> <password>");
						System.out.println("sample <numSamples> <table or query>");
						System.out.println("\\t [enter] rerun last command");
						System.out.println("exit");
						break;
					default:
						if(command.length() > 0) System.out.println("Unknown Command" + command);
			}
		} while(!command.equals("exit"));
	}
	
	private static int getNumRecordsFromTable(String table, Connection c) {
		int numRecords = 0;
		try {
			Statement stmt = c.createStatement();
			ResultSet data = stmt.executeQuery("select count(*) as rowCount from " + table + " as countTable;");
			if(data.next()) {
				numRecords = data.getInt("rowCount");
			}
			stmt.close();
		} catch(SQLException e) {
			System.out.println("Error: Cannot read number of records in table " + table);
			numRecords = -1;
		}
		
		return numRecords;
	}
	
}

