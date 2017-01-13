within Buildings.HeatTransfer.Conduction.BaseClasses;
function computeCTF
  "Store the value u at the element n in the external object, and return the value of the element i"
  input Buildings.HeatTransfer.Conduction.BaseClasses.CTFData ctfData
    "External object that contains the CTF data";
  input Modelica.SIunits.Time t
    "Model time";
  input Modelica.SIunits.HeatFlowRate Q_a_flow
    "Heat flow rate at surface a";
  input Modelica.SIunits.HeatFlowRate Q_b_flow
    "Heat flow rate at surface b";
  output Modelica.SIunits.Temperature T_a
    "Temperature at surface a";
  output Modelica.SIunits.Temperature T_b
    "Temperature at surface a";

  // Note that retVal should always be 0, as any error in the CTF
  // code need to be handled with a call to ModelicaError.

  output Integer retVal "Return value of the CTF calculation";

  external"C" retVal = computeCTF(ctfData, t, Q_a_flow, Q_b_flow, T_a, T_b)
  annotation (Include="#include <computeCTF.c>",
                   IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation (Documentation(info="<html>
<p>
External function that invokes the CTF calculation.
</p>
</html>",   revisions="<html>
<ul>
<li>
January 12, 2017, by Michael Wetter:<br/>
First implementation
</li>
</ul>
</html>"));
end computeCTF;
