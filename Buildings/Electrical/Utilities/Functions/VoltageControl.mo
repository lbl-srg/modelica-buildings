within Buildings.Electrical.Utilities.Functions;
model VoltageControl
  "This model represents a simple voltage controller that unplug a load when there is a voltage fluctuation higher that a given threshold."
  Modelica.Blocks.Interfaces.RealInput V "Voltage of the node to be controlled";
  parameter Modelica.SIunits.Voltage V_nominal
    "Nominal voltage of the node to be controlled";
  parameter Real Vthresh(min=0.0, max=1.0)
    "Threshold that activates voltage ctrl (ratio of nominal voltage)";
  parameter Modelica.SIunits.Time Tdelay = 300
    "Time to wait before plugging the load back";
  output Real y
    "Output signal that represents whether the load should be connected to the grid or not";
protected
  discrete Boolean connected;
  discrete Real Tswitch;
initial algorithm
  connected := true;
  Tswitch := 0;
equation

  // Output for every state, connected or not
  if connected then
    y = 1.0;
  else
    y = 0.0;
  end if;

algorithm
  when
      (connected and (V > V_nominal*(1+Vthresh) or V < V_nominal*(1-Vthresh))) then
    Tswitch := time;
    connected := false;
  end when;

  // Transition between not connected and connected again after the delay time has been elapsed
  when
      (not connected and time >= Tswitch + Tdelay) then
    connected := true;
  end when;

end VoltageControl;
