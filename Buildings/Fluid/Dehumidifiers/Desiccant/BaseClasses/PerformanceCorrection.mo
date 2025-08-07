within Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses;
model PerformanceCorrection
  "Desiccant dehumidifier performance adjustment based on wheel speed"
  parameter Buildings.Fluid.Dehumidifiers.Desiccant.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-40,-78},{-20,-58}})));
  Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.SpeedCorrection speCor(
    final per=per)
    "Correct the dehumidifier performance based on the wheel speed"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance dehPer(
    final per=per) "Dehumidifier performance calculation"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Math.Add add(
    final k1=-1)
   "Temperature difference in the process air"
    annotation (Placement(transformation(extent={{40,44},{60,64}})));
  Modelica.Blocks.Math.Add add1(
    final k1=-1) "Humidity difference in the process air"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Modelica.Blocks.Math.Product product1
    "Correct temperature difference in the process air"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Math.Add add2
    "Corrected temperature of the process air leaving the dehumidifier"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));
  Modelica.Blocks.Math.Product product2
    "Corrected humidity difference in the process air"
    annotation (Placement(transformation(extent={{100,-14},{120,6}})));
  Modelica.Blocks.Math.Add add3(
    final k1=-1)
    "Correct humidity ratio of the process air leaving the dehumidifier"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Modelica.Blocks.Math.Product product3
    "Corrected mass flow rate of the regeneration air"
    annotation (Placement(transformation(extent={{160,-60},{180,-40}})));
  Modelica.Blocks.Logical.Hysteresis hys(
    final uLow=per.uSpe_min,
    final uHigh=per.uSpe_min + 0.05)
    "Convert real input to boolean output "
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Math.Product product4
    "Corrected mass flow rate of the regeneration air"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Interfaces.RealInput mPro_flow(
    final unit="kg/s")
    "Mass flow rate of the process air"
    annotation (Placement(transformation(
    extent={{-124,-92},{-100,-68}}),
    iconTransformation(extent={{-120,-92},{-100,-72}})));
  Modelica.Blocks.Interfaces.RealInput TProEnt(
    final unit="K") "Temperature of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-124,28},{-100,52}}),
    iconTransformation(extent={{-120,32},{-100,52}})));
  Modelica.Blocks.Interfaces.RealInput TRegEnt(
    final unit="K")
    "Temperature of the regeneration air entering the dehumidifier"
    annotation(Placement(transformation(extent={{-124,-12},{-100,12}}),
    iconTransformation(extent={{-120,10},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput X_w_ProEnt(
    final unit="kg/kg")
    "Humidity ratio of the process air entering the dehumidifier"
    annotation (Placement(transformation(
    extent={{-124,-52},{-100,-28}}),
    iconTransformation(extent={{-120,-48},{-100,-28}})));
  Modelica.Blocks.Interfaces.RealInput uSpe(
    final unit="1",
    final min=0,
    final max=1)
    "Wheel speed ratio"
    annotation (Placement(transformation(extent={{-124,68},{-100,92}}),
    iconTransformation(extent={{-120,72},{-100,92}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    final unit="W")
    "Electric power consumption"
    annotation (Placement(transformation(extent={{200,70},{220,90}}),
    iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput TProLea(
    final unit="K")
    "Temperature of the process air leaving the dehumidifier"
    annotation (Placement(transformation(extent={{200,30},{220,50}}),
    iconTransformation(
    extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput X_w_ProLea(
    final unit="1")
    "Humidity ratio of the process air leaving the dehumidifier"
    annotation (Placement(transformation(extent={{200,-10},{220,10}}),
    iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput mReg_flow(
    final unit="kg/s")
    "Mass flow rate of the regeneration air"
    annotation (Placement(transformation(extent={{200,-60},{220,-40}}),
    iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput hReg(
    final unit="J/kg")
    "Specific regeneration energy"
    annotation (Placement(transformation(extent={{200,-90},{220,-70}}),
    iconTransformation(extent={{100,-90},{120,-70}})));

equation
  connect(dehPer.X_w_ProEnt, X_w_ProEnt) annotation (Line(points={{-21,-3.8},{-70,
          -3.8},{-70,-40},{-112,-40}}, color={0,0,127}));
  connect(dehPer.TProEnt, TProEnt) annotation (Line(points={{-21,4.2},{-60,4.2},
          {-60,40},{-112,40}}, color={0,0,127}));
  connect(speCor.uSpe, uSpe)
    annotation (Line(points={{-22,80},{-112,80}}, color={0,0,127}));
  connect(add.u1, TProEnt) annotation (Line(points={{38,60},{-10,60},{-10,40},{-112,
          40}}, color={0,0,127}));
  connect(dehPer.TProLea, add.u2)
    annotation (Line(points={{1,8},{20,8},{20,48},{38,48}},  color={0,0,127}));
  connect(add1.u1, dehPer.X_w_ProLea)
    annotation (Line(points={{38,-4},{32,-4},{32,4},{1,4}},  color={0,0,127}));
  connect(add1.u2, X_w_ProEnt) annotation (Line(points={{38,-16},{-70,-16},{-70,
          -40},{-112,-40}}, color={0,0,127}));
  connect(speCor.epsSenCor, product1.u1) annotation (Line(points={{2,80},{80,80},
          {80,66},{98,66}}, color={0,0,127}));
  connect(add.y, product1.u2) annotation (Line(points={{61,54},{98,54}},
          color={0,0,127}));
  connect(add2.u2, TProEnt) annotation (Line(points={{138,24},{-60,24},{-60,40},
          {-112,40}}, color={0,0,127}));
  connect(product1.y, add2.u1) annotation (Line(points={{121,60},{130,60},{130,36},
          {138,36}}, color={0,0,127}));
  connect(add1.y, product2.u2) annotation (Line(points={{61,-10},{98,-10}},
          color={0,0,127}));
  connect(speCor.epsLatCor, product2.u1)
    annotation (Line(points={{2,72},{70,72},{70,2},{98,2}}, color={0,0,127}));
  connect(product2.y, add3.u1) annotation (Line(points={{121,-4},{130,-4},{130,-14},
          {138,-14}}, color={0,0,127}));
  connect(add3.u2, X_w_ProEnt) annotation (Line(points={{138,-26},{-70,-26},{-70,
          -40},{-112,-40}}, color={0,0,127}));
  connect(add2.y, TProLea) annotation (Line(points={{161,30},{176,30},{176,40},{
          210,40}}, color={0,0,127}));
  connect(add3.y, X_w_ProLea)
    annotation (Line(points={{161,-20},{180,-20},{180,0},{210,0}}, color={0,0,127}));
  connect(speCor.P, P) annotation (Line(points={{2,88},{194,88},{194,80},{210,80}},
        color={0,0,127}));
  connect(dehPer.mPro_flow, mPro_flow) annotation (Line(points={{-21,-8.2},{-90,
          -8.2},{-90,-80},{-112,-80}}, color={0,0,127}));
  connect(product3.y, mReg_flow)
    annotation (Line(points={{181,-50},{210,-50}}, color={0,0,127}));
  connect(product3.u2, dehPer.mReg_flow) annotation (Line(points={{158,-56},{20,
          -56},{20,-4},{1,-4}},                     color={0,0,127}));
  connect(product3.u1, uSpe) annotation (Line(points={{158,-44},{-80,-44},{-80,80},
          {-112,80}}, color={0,0,127}));
  connect(dehPer.hReg, product4.u1)
  annotation (Line(points={{1,-8},{10,-8},{10,-74},{98,-74}}, color={0,0,127}));
  connect(product4.u2, uSpe) annotation (Line(points={{98,-86},{-80,-86},{-80,80},
          {-112,80}}, color={0,0,127}));
  connect(product4.y, hReg)
    annotation (Line(points={{121,-80},{210,-80}}, color={0,0,127}));
  connect(dehPer.TRegEnt, TRegEnt)
    annotation (Line(points={{-21,0},{-112,0}}, color={0,0,127}));
  connect(hys.y, dehPer.uRot) annotation (Line(points={{-39,60},{-30,60},{-30,8.2},
          {-21,8.2}}, color={255,0,255}));
  connect(hys.u, uSpe) annotation (Line(points={{-62,60},{-80,60},{-80,80},{-112,
          80}},      color={0,0,127}));
  annotation (defaultComponentName="dehPerCor",
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
            graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(
          points={{-70,22},{-54,50},{-12,78},{32,78},{62,60},{82,14}},
          color={28,108,200},
          thickness=0.5),
        Ellipse(extent={{-34,10},{38,-88}}, lineColor={28,108,200},
          lineThickness=0.5),
        Text(
          extent={{-62,20},{-32,-20}},
          textColor={0,0,88},
          textString="u"),
        Line(points={{-24,-4},{12,32},{0,24},{12,32}},
        color={28,108,200},
          thickness=0.5),
        Line(points={{12,32},{6,20}}, color={28,108,200},
          thickness=0.5),               Text(
        extent={{-158,148},{142,108}},
        textString="%name",
        textColor={0,0,255})}),
                             Diagram(coordinateSystem(preserveAspectRatio=false, extent={
            {-100,-100},{200,100}})),
    Documentation(info="<html>
<p>
This model adjusts the outlet conditions of the process air in a desiccant dehumidifier to account for the effect of wheel speed.
</p>
<p>
Specifically, the temperature of the process air leaving the dehumidifier, <code>TProLea</code>, is calculated as:
</p>
<p align=\"center\" style=\"font-style: italic;\">
TProLea = (TProLea - TProEnt) * epsSenCor + TProEnt
</p>
<p>
Similarly, the humidity ratio of the process air leaving the dehumidifier, <code>X_w_ProLea</code>, is calculated as:
</p>
<p align=\"center\" style=\"font-style: italic;\">
X_w_ProLea = X_w_ProEnt - (X_w_ProEnt - X_w_ProLea) * epsLatCor
</p>
<p>
Here, <code>TProEnt</code> and <code>X_w_ProEnt</code> represent the temperature and humidity ratio of the process air entering the dehumidifier, respectively.
<code>uSpe</code> is the wheel speed ratio.
<code>epsSenCor</code> is the sensible heat exchange effectiveness correction based on <code>uSpe</code>
(see details in <a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionSensible\">
Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionSensible</a>), and
<code>epsLatCor</code> is the latent heat exchange effectiveness correction based on <code>uSpe</code>
(see details in <a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionLatent\">
Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionLatent</a>).
</p>
<p>
This model also adjusts the regeneration flow rate and the specific regeneration energy, assuming both are proportional to <code>uSpe</code>.
</p>
Finally, it also calculates the wheel power consumption based on <code>uSpe</code> (see details in <a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionSensible\">
Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionSensible</a>).
</html>", revisions="<html>
<ul>
<li>July 17, 2025, by Sen Huang:<br/>
First implementation.</li>
</ul>
</html>"));
end PerformanceCorrection;
