within Buildings.Utilities.Plotters.Examples;
model SingleZoneVAVSupply_u
  "Scatter plots for control signal of a single zone VAV controller from ASHRAE Guideline 36"
   extends Modelica.Icons.Example;

  inner Configuration plotConfiguration(samplePeriod=0.005) "Plot configuration"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract heaCooConSig
    "Add control signal for heating (with negative sign) and cooling"
    annotation (Placement(transformation(extent={{-32,40},{-12,60}})));
  Buildings.Utilities.Plotters.Scatter scaTem(
    title="Temperature setpoints",
    n=2,
    xlabel="Heating (negative) and cooling (positive) control loop signal",
    legend={"THea [degC]","TCoo [degC]"},
    introduction="Set point temperatures as a function of the heating loop signal (from -1 to 0) and
the cooling loop signal (from 0 to +1).")
    "Scatter plot for temperature setpoints"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.UnitConversions.To_degC THea_degC
    "Control signal for heating"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.UnitConversions.To_degC TCoo_degC
    "Control signal for cooling"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Utilities.Plotters.Scatter scaYFan(
    n=1,
    title="Fan control signal",
    legend={"yFan"},
    xlabel="Heating (negative) and cooling (positive) control loop signal",
    introduction="Fan speed as a function of the heating loop signal (from -1 to 0) and
the cooling loop signal (from 0 to +1).")
    "Scatter plot for fan speed"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply setPoiVAV(
    yHeaMax=0.7,
    yMin=0.3,
    TSupSetMax=303.15,
    TSupSetMin=289.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(
    k = 273.15 + 28)
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut(k=273.15 + 22)
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uHea(
    duration=0.25,
    height=-1,
    offset=1) "Heating control signal"
    annotation (Placement(transformation(extent={{-80,46},{-60,66}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uCoo(
    duration=0.25,
    startTime=0.75)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetZon(k=273.15 + 23)
    "Average zone set point"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanSta(k=true) "Fan is on"
      annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

equation
  connect(TOut.y, setPoiVAV.TOut) annotation (Line(points={{-58,-70},{-46,-70},{
          -46,-15},{-2,-15}},
                            color={0,0,127}));
  connect(uHea.y, setPoiVAV.uHea) annotation (Line(points={{-58,56},{-44,56},{-44,
          -1.66667},{-2,-1.66667}},
                        color={0,0,127}));
  connect(uCoo.y, setPoiVAV.uCoo) annotation (Line(points={{-58,20},{-40,20},{-40,
          -5},{-2,-5}}, color={0,0,127}));

  connect(scaTem.x, heaCooConSig.y) annotation (Line(points={{98,-8},{90,-8},{90,
          50},{-10,50}},      color={0,0,127}));
  connect(THea_degC.y, scaTem.y[1]) annotation (Line(points={{62,20},{70,20},{
          70,-0.5},{98,-0.5}},
                        color={0,0,127}));
  connect(TCoo_degC.y, scaTem.y[2]) annotation (Line(points={{62,-10},{70,-10},
          {70,0.5},{98,0.5}},
                           color={0,0,127}));
  connect(setPoiVAV.y, scaYFan.y[1]) annotation (Line(points={{22,-15},{30,-15},
          {30,-50},{98,-50}},
                           color={0,0,127}));
  connect(heaCooConSig.y, scaYFan.x) annotation (Line(points={{-10,50},{90,50},{
          90,-58},{98,-58}},    color={0,0,127}));
  connect(setPoiVAV.TZon, TZon.y) annotation (Line(points={{-2,-11.6667},{-50,
          -11.6667},{-50,-40},{-58,-40}},
                           color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco, THea_degC.u) annotation (Line(points={{22,-5},{30,
          -5},{30,20},{38,20}}, color={0,0,127}));
  connect(setPoiVAV.TSupCoo, TCoo_degC.u)
    annotation (Line(points={{22,-10},{38,-10}}, color={0,0,127}));
  connect(TSetZon.y, setPoiVAV.TZonSet)
    annotation (Line(points={{-58,-10},{-30,-10},{-30,-8.33333},{-2,-8.33333}},
                                                  color={0,0,127}));
  connect(fanSta.y, setPoiVAV.uFan)
    annotation (Line(points={{-18,-50},{-10,-50},{-10,-18.3333},{-2,-18.3333}},
                                                                      color={255,0,255}));
  connect(uHea.y, heaCooConSig.u2) annotation (Line(points={{-58,56},{-44,56},{-44,
          44},{-34,44}}, color={0,0,127}));
  connect(uCoo.y, heaCooConSig.u1) annotation (Line(points={{-58,20},{-40,20},{-40,
          56},{-34,56}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{140,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Plotters/Examples/SingleZoneVAVSupply_u.mos"
        "Simulate and plot"),
    Documentation(
info="<html>
<p>
This example demonstrates how to create a scatter plot that shows
for a single zone VAV control logic
the heating and cooling set point temperatures, and the fan speed,
all as a function of the heating and cooling control signal.
The sequence that will be used to plot the sequence diagram is
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply</a>
and shown below.
The plot will be generated in the file <code>plots.html</code>.
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/SetPoints/Supply.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleZoneVAVSupply_u;
