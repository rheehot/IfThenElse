/**
 * Copyright 2011-2012  Martijn Koedam <qball@gmpclient.org>
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of 
 * the License.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
using GLib;

namespace IfThenElse
{

	public class ExternalToolCheck : BaseCheck
	{
		public string cmd {get; set; default = "";}
		public string? output_compare { get; set; default=null;}
		public bool state = false;
		
		/**
		 * Constructor
		 **/
		public ExternalToolCheck()
		{
			
		}
		/*
		 * Check function.
		 */
		public override BaseCheck.StateType check()
		{
			try{
				int exit_value = 1;
				string output = null;
				GLib.Process.spawn_command_line_sync(cmd,
							out output, null, out exit_value);
				exit_value = GLib.Process.exit_status(exit_value);
				stdout.printf("output: %i:%s vs %s\n", exit_value, output, output_compare);
				if(output_compare == null)
				{
					if(exit_value ==  1){
						return StateType.TRUE;
					}else if (exit_value == 8) {
						return StateType.FALSE;
					}else{
						return StateType.NO_CHANGE;
					}
				}else{
						if(output_compare.strip() == output.strip())
						{
							return StateType.TRUE;
						} else {
							return StateType.FALSE;
						}
				}
			} catch(GLib.SpawnError e) {
					GLib.error("Failed to spawn external program: %s\n",
						e.message);
			}
			return StateType.NO_CHANGE;
		}
	}
}

