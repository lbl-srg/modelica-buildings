within Buildings.Fluid.SolarCollectors.BaseClasses;
block EN12975HeatLoss
  "Calculate the heat loss of a solar collector per EN12975"

  extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialHeatLoss(final T_nominal = TMean_nominal);

  parameter Modelica.SIunits.CoefficientOfHeatTransfer C1
    "C1 from ratings data";
  parameter Real C2(
  final unit = "W/(m2.K2)") "C2 from ratings data";
  parameter Modelica.SIunits.Temperature TMean_nominal
    "Inlet temperature at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
protected
  final parameter Modelica.SIunits.ThermalConductance UA(
     fixed = false,
     start=QLos_nominal/(TMean_nominal - TEnv_nominal))
    "Coefficient describing heat loss to ambient conditions";
initial equation
   //Identifies QUse at nominal conditions
   QUse_nominal = G_nominal * A_c * y_intercept -C1 * A_c *
      (TMean_nominal - TEnv_nominal) - C2 * A_c * (TMean_nominal - TEnv_nominal)^2;
   //Identifies TFlu[nSeg] at nominal conditions
   m_flow_nominal * Cp_nominal * (TFlu_nominal[nSeg] - TMean_nominal) = QUse_nominal;
   //Identifies QLos at nominal conditions
   QLos_nominal = -C1 * A_c * (TMean_nominal - TEnv_nominal)-C2 * A_c * (TMean_nominal - TEnv_nominal)^2;
   //Governing equation for the first segment (i=1)
   G_nominal * y_intercept * A_c/nSeg - UA/nSeg * (TMean_nominal - TEnv_nominal)
     = m_flow_nominal * Cp_nominal * (TFlu_nominal[1] - TMean_nominal);
   //Loop with the governing equations for segments 2:nSeg-1
   for i in 2:nSeg-1 loop
     G_nominal * y_intercept * A_c/nSeg - UA/nSeg * (TFlu_nominal[i-1] - TEnv_nominal)
      = m_flow_nominal * Cp_nominal * (TFlu_nominal[i] - TFlu_nominal[i-1]);
   end for;
   for i in 1:nSeg loop
     nSeg * QLosUA[i] = UA * (TFlu_nominal[i] - TEnv_nominal);
   end for;
   sum(QLosUA) = QLos_nominal;
equation
   for i in 1:nSeg loop
     QLos[i] * nSeg = UA * (TFlu[i] - TEnv);
   end for;
  annotation (
    defaultComponentName="heaLos",
    Documentation(info="<html>
<p>
This component computes the heat loss from the flat plate solar collector to the environment. It is designed anticipating ratings data collected in
accordance with EN12975. A negative <code>QLos[i]</code> indicates that heat is being lost to the environment.
</p>
<p>
This model calculates the heat lost from a multiple-segment model using ratings data based on the mean collector temperature. As a result, the slope from
the ratings data must be converted to a <i>UA</i> value which, for a given number of segments, returns the same heat loss as the ratings data would at 
nominal conditions. The <i>UA</i> value is identified using the system of equations below:
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Use,nom</sub> = G<sub>nom</sub> A<sub>c</sub> F<sub>R</sub>(&tau;&alpha;) - C<sub>1</sub> A<sub>c</sub> (T<sub>Mean,nom</sub>-T<sub>Env,nom</sub>)-C<sub>2</sub> A<sub>c</sub> (T<sub>Mean,nom</sub>-T<sub>Env,nom</sub>)<sup>2</sup><br/>
T<sub>Fluid,nom</sub>[nSeg]=T<sub>Mean,nom</sub>+Q<sub>Use,nom</sub>/(m<sub>flow,nom</sub> C<sub>p</sub>)<br/>
Q<sub>Los,nom</sub>=-C<sub>1</sub> A<sub>c</sub> (T<sub>Mean,nom</sub>-T<sub>Env,nom</sub>)-C<sub>2</sub> A<sub>c</sub> (T<sub>Mean,nom</sub>-T<sub>Env,nom</sub>)<sup>2</sup><br/>
T<sub>Fluid,nom</sub>[i] = T<sub>Fluid,nom</sub>[i-1] + (G<sub>nom</sub> F<sub>R</sub>(&tau;&alpha;) A<sub>c</sub>/nSeg - UA/nSeg (T<sub>Fluid,nom</sub>[i-1]-T<sub>Env,nom</sub>))/(m<sub>Flow,nom</sub> c<sub>p</sub>)<br/>
Q<sub>Loss,UA</sub>=UA/nSeg (T<sub>Fluid,nom</sub>[i]-T<sub>Env,nom</sub>)<br/>
sum(Q<sub>Loss,UA</sub>[1:nSeg])=Q<sub>Loss,nom</sub>
</p>
<p>
The effective <i>UA</i> value is calculated at the beginning of the simulation and used as a constant through the rest of the simulation. The actual heat 
loss from the collector is calculated using:
</p>
<p align=\"center\" style=\"font-style:italic;\">
-Q<sub>Loss</sub>[i] = UA/nSeg (T<sub>Fluid</sub>[i] - T<sub>Env</sub>)
</p>

<h4>References</h4>
<p>
CEN 2006, European Standard 12975-1:2006, European Committee for Standardization 
</p>
</html>", revisions="<html>
<ul>
<li>
Jan 16, 2012, by Peter Grant:<br/>
First implementation
</li>
</ul>
</html>"),
    Diagram(graphics),
    Icon(graphics={Text(
          extent={{-48,-32},{36,-66}},
          lineColor={0,0,255},
          textString="%name")}));
end EN12975HeatLoss;
