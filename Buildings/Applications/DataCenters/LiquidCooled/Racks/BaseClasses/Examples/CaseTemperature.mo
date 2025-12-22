within Buildings.Applications.DataCenters.LiquidCooled.Racks.BaseClasses.Examples;
model CaseTemperature "Example model for case temperature"
  extends Modelica.Icons.Example;

  parameter Integer nPar = 4 "Number of parallel cold plates";
  Buildings.Applications.DataCenters.LiquidCooled.Racks.BaseClasses.CaseTemperature
    casTem(datRes=ocpOAM3, V_flow_nominal=2.5/60/1000) "Case temperature"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Controls.OBC.CDL.Reals.Sources.Ramp V_flow(
   y(final unit="m3/s"),
    height(
      final unit="m3/s",
      displayUnit="dm3/min") = 0.00013333333333333,
    duration=1,
    offset(
      final unit="m3/s",
      displayUnit="dm3/min") = 0.0001,
    startTime=0) "Volume flow rate"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Controls.OBC.CDL.Reals.Sources.Constant TIn(k=273.15 + 30)
                                                        "Inlet temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Controls.OBC.CDL.Reals.Sources.Constant P(k=1000) "Heat flow rate"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  parameter Data.Generic_R_m_flow ocpOAM3(
    V_flow=nPar*{1.5,2.0,2.5,3.0,3.5}/60/1000,
    R={0.0183,0.0176,0.0170,0.0166,0.0157},
    n=2)                                    "Data from OCP report, figure 13"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(V_flow.y, casTem.V_flow) annotation (Line(points={{-58,30},{-20,30},{
          -20,6},{9,6}},
                      color={0,0,127}));
  connect(TIn.y, casTem.TIn)
    annotation (Line(points={{-58,0},{9,0}},  color={0,0,127}));
  connect(P.y, casTem.Q_flow) annotation (Line(points={{-58,-30},{-20,-30},{-20,
          -6},{9,-6}},  color={0,0,127}));
  annotation (
   experiment(
     StartTime=0,
     Tolerance=1e-6,
     StopTime=1),
     __Dymola_Commands(
       file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/LiquidCooled/Racks/BaseClasses/Examples/CaseTemperature.mos" "Simulate and plot"),

  Documentation(info="<html>
<p>
Example model that computes the cold plate case temperature
for different volume flow rates and constant heat input of
<i>1</i> kW.
The data is based on Figure 13 from Chen et al. (2022).
</p>
<h4>References</h4>
<p>
Cheng Chen, Dennis Trieu, Tejas Shah, Allen Guo, Jaylen Cheng, Christopher Chapman, Sukhvinder Kang,
Eran Dagan, Assaf Dinstag,Jane Yao.
<a href=\"https://www.opencompute.org/documents/oai-system-liquid-cooling-guidelines-in-ocp-template-mar-3-2023-update-pdf\">
OCP OAI SYSTEM LIQUID COOLING GUIDELINES</a>.
2023.
<p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CaseTemperature;
