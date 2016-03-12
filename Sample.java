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
        boolean lastCommandViable = true;
		
		url = "jdbc:postgresql://stampy.cs.wisc.edu/cs564instr?sslfactory=org.postgresql.ssl.NonValidatingFactory&ssl";
		username = "";
		previousCommand = "";
		command = "";
		
		//print out some helpful information like commands and help menu
        System.out.println("\ntype \"help\" for commands and information\n");
		
		do {
			if(!redoingCommand) System.out.print(username + "> ");
			if(!command.equals("") && !command.equals("help") && lastCommandViable) previousCommand = command;
			if(!redoingCommand) {command = in.nextLine(); command = command.trim();}
			redoingCommand = false;
            lastCommandViable = true;
			switch(command.split(" ")[0]) {
					case "seed":
						//make sure they passed in a number for the seed
						try {
							seed = Integer.parseInt(command.split(" ")[1]);
							rng = new Random(seed);
							System.out.println("Seed set to " + seed);
						} catch (NumberFormatException e) {
							System.out.println(command.split(" ")[1] + " is not a valid seed. It must be an integer.");
							System.out.println("Usage: > seed <seed value>");
						}
						break;
					case "sample":
						String query = "";
						String table = "";
						int numSamples = 0;
						int numRecords = 0;
						
						if(c == null) {
							System.out.println("Error: connect to a database first. Use the 'connect' command.");
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
							
                            //print column names here
                            boolean firstTime = true;
							while(numSelected < numSamples) {
								if((numRecords - numConsidered) * rng.nextFloat() < numSamples - numSelected) {
									//include the (numConsidered + 1)st record. Slightly different than in the project spec
									fetchAndPrintRecord(table, true, numConsidered, c, firstTime);
                                    firstTime = false;
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
							
							numRecords = getNumRecordsFromQuery(query, c);
							if(numRecords < 0) break;
							
							int numConsidered = 0;
							int numSelected = 0;
							
							boolean printAll = numRecords < numSamples;
							numSamples = Math.min(numRecords, numSamples);
							
                            //print column names here
							boolean firstTime = true;
							while(numSelected < numSamples) {
								if((numRecords - numConsidered) * rng.nextFloat() < numSamples - numSelected) {
									//include the (numConsidered + 1)st record. Slightly different than in the project spec
									fetchAndPrintRecord(query, false, numConsidered, c, firstTime);
                                    firstTime = false;
									numSelected++;
								}
								numConsidered++;
							}
							
							if(printAll) {
								System.out.println("Note: All records of query were returned.");
							}
								
						} else {
							System.out.println("Usage: > sample <number> <table or query>");
							break;
						}
						
						break;
					case "connect":
						String password = "";
                        String previousURL = "";
						String className = "org.postgresql.Driver";

						try {
							Class.forName(className);
						} catch (ClassNotFoundException e) {
							System.out.println("Error: Class name " + className + " not found");
						}
						
						if(command.split(" ").length == 4) {
                            previousURL = url;
							url = command.split(" ")[1];
							username = command.split(" ")[2];
							password = command.split(" ")[3];
						} else if(command.split(" ").length == 2) {
                            previousURL = url;
                            url = command.split(" ")[1];                            
                        } else if(command.split(" ").length != 1) {
                            System.out.println("Usage: > connect [url] <username> <password>");
                            break;
                        }
    
                        try {
                            if(command.split(" ").length == 4) {                           
    							c = DriverManager.getConnection(url, username, password);
                            } else {
                                c = DriverManager.getConnection(url);
                            }
						} catch(SQLException e) {
							System.out.println("Error: Cannot get connection to " + url);
							username = "";
                            url = previousURL;
							e.printStackTrace();
						}			
						
						break;
                    case "q":
                    case "quit":
					case "exit": 
						try {
							if(c != null) c.close();
						} catch (SQLException e) {
							System.out.println("Error: Unable to close connection");
						}
						System.exit(1);
						break;
					case "r":
						redoingCommand = true;
						command = previousCommand;
						break;
					case "help":
						System.out.println("\n------ helpful information ------");
						System.out.println("url  = " + url);
						System.out.println("user = " + (username.equals("") ? "(Not signed in as a user)" : username));
						System.out.println("seed = " + seed);
						System.out.println("last command = " + previousCommand);
						System.out.println("\n------ commands ------");
						System.out.println("seed <seed value>");
                        System.out.println("\t +gives the specified seed to RNGesus.\n");
						System.out.println("connect");
                        System.out.println("\t +connects you to the last url it was able to connect to. Default url otherwise.");
                        System.out.println("connect <url>");
                        System.out.println("\t +connects you to the specified url.");
                        System.out.println("connect <url> <username> <password>");
                        System.out.println("\t +connects you to the specified url with the given credentials.\n");
						System.out.println("sample <numSamples> <table or query>");
                        System.out.println("\t +sample the specified number of samples from the table or query");
                        System.out.println("\t + ex. \"sample 5 holidays\"");
                        System.out.println("\t + ex. \"sample 5 select * from holidays where isholiday = false and weekdate < '2011-05-06'\"\n");
						System.out.println("r");
                        System.out.println("\t +re-execute the last command.\n");
						System.out.println("exit, quit, q");
						break;
					default:
						if(command.length() > 0) System.out.println("Unknown Command : " + command);
                        lastCommandViable = false;
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
			System.out.println("Error: Cannot get number of records in table :" + table);
			numRecords = -1;
		}
		
		return numRecords;
	}
	
	private static int getNumRecordsFromQuery(String query, Connection c) {
		int numRecords = 0;
		try {
			Statement stmt = c.createStatement();
			ResultSet data = stmt.executeQuery("select count(*) as rowCount from (" + query + ") as countTable;");
			if(data.next()) {
				numRecords = data.getInt("rowCount");
			}
			stmt.close();
		} catch(SQLException e) {
			System.out.println("Error: Cannot read number of records in query");
			numRecords = -1;
		}
		
		return numRecords;
	}
	
	private static void fetchAndPrintRecord(String query, boolean isTable, int numConsidered, Connection c, boolean printColNames) {
		try {
			Statement stmt = c.createStatement();
			ResultSet rs;
			if(isTable) {
				rs = stmt.executeQuery("select * from (select ROW_NUMBER() over () as rownum, * from " + query + ") as tbl where tbl.rownum = " + (numConsidered + 1) + ";");
			} else {
				rs = stmt.executeQuery("select * from (select ROW_NUMBER() over () as rownum, * from (" + query + ") as someHopefullyUniqueTableName) as tbl where tbl.rownum = " + (numConsidered + 1) + ";");
			}
			ResultSetMetaData rsmd = rs.getMetaData();
			ArrayList<String> cols = new ArrayList<String>();
			for(int i = 1; i <= rsmd.getColumnCount(); i++) {
				if(!rsmd.getColumnName(i).equals("rownum")) {
                    cols.add(rsmd.getColumnName(i));                  
                }
			}

			while(rs.next()) {
                if(printColNames) {
                    for(int i = 0; i < cols.size(); i++) {
                        System.out.print(cols.get(i) + ((i != cols.size() - 1) ? " | " : ""));
				    }
                    System.out.println();
                }
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
			System.out.println("Error: Cannot process sample query");
			e.printStackTrace();
		}
	}
	
}

