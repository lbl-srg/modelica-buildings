within Buildings.ThermalZones.Detailed.Examples.Controls;
block ElectrochromicWindow "Controller for electrochromic windows"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Irradiance HClear=250
    "Solar irradiation below which the window will be in clear state regardless of temperature";
  parameter Modelica.Units.SI.Irradiance HDark=HClear + 100
    "Solar irradiation at which the window will be in dark state if T > TDark";
  parameter Modelica.Units.SI.Temperature TClear=273.15 + 22
    "Measured temperature below which the window will be in clear state for any irradiation";
  parameter Modelica.Units.SI.Temperature TDark=TClear + 2
    "Measured temperature above which the window will be transitioned to completely dark state if H > HDark";

  Modelica.Blocks.Interfaces.RealInput T(
    quantity="ThermodynamicTemperature",
    unit="K")
    "Temperature used for control" annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}), iconTransformation(extent={{-130,25},
            {-100,55}})));

  Modelica.Blocks.Interfaces.RealInput H(
    quantity="RadiantEnergyFluenceRate",
    unit="W/m2")
    "Direct solar radiation onto window" annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}), iconTransformation(
          extent={{-130,-55},{-100,-25}})));

  Modelica.Blocks.Interfaces.RealOutput y "Control signal for window"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Modelica.Blocks.Sources.Constant TLow(final k=TClear) "Lower temperature"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Modelica.Blocks.Nonlinear.Limiter limT(
    final uMax=1,
    final uMin=0,
    final strict=true) "Limiter for temperature"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Modelica.Blocks.Math.Feedback feeT "Feedback for temperature"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Modelica.Blocks.Math.Gain gaiT(final k=1/(TDark - TClear))
    "Gain for temperature"
    annotation (Placement(transformation(extent={{-8,30},{12,50}})));

  Modelica.Blocks.Sources.Constant HLow(final k=HClear) "Lower irradiation"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

  Modelica.Blocks.Nonlinear.Limiter limH(
    final uMax=1,
    final uMin=0,
    final strict=true) "Limiter for irradiation"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Blocks.Math.Feedback feeH "Feedback for irradiation"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Modelica.Blocks.Math.Gain gaiH(final k=1/(HDark - HClear))
    "Gain for irradiation"
    annotation (Placement(transformation(extent={{-8,-50},{12,-30}})));

  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

equation
  connect(TLow.y, feeT.u2)
    annotation (Line(points={{-59,20},{-40,20},{-40,32}}, color={0,0,127}));
  connect(feeT.u1, T)
    annotation (Line(points={{-48,40},{-76,40},{-120,40}}, color={0,0,127}));
  connect(feeT.y, gaiT.u)
    annotation (Line(points={{-31,40},{-10,40}}, color={0,0,127}));
  connect(gaiT.y, limT.u)
    annotation (Line(points={{13,40},{28,40}}, color={0,0,127}));
  connect(H, feeH.u1)
    annotation (Line(points={{-120,-40},{-48,-40}}, color={0,0,127}));
  connect(HLow.y, feeH.u2)
    annotation (Line(points={{-59,-60},{-40,-60},{-40,-48}}, color={0,0,127}));
  connect(feeH.y, gaiH.u)
    annotation (Line(points={{-31,-40},{-20,-40},{-10,-40}}, color={0,0,127}));
  connect(gaiH.y, limH.u)
    annotation (Line(points={{13,-40},{28,-40},{28,-40}}, color={0,0,127}));
  connect(limT.y, product.u1)
    annotation (Line(points={{51,40},{58,40},{58,6},{68,6}}, color={0,0,127}));
  connect(limH.y, product.u2) annotation (Line(points={{51,-40},{58,-40},{58,-6},
          {68,-6}}, color={0,0,127}));
  connect(product.y, y)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  annotation (
  defaultComponentName="conWin",
            Documentation(info="<html>
<p>
Controller for electrochromic windows.
If the temperature <em>or</em> the irradiation is below <code>TClear</code> or <code>HClear</code>, then
the window is in the clear state, allowing for passive heating and for view if the room is cool enough.
If the temperature and the irradition is above <code>TDark</code> and <code>HDark</code>, then
the window is in the dark state, thereby protecting the room from too much solar gain.
For each of these measured quantity, the respective control signal is a linear function, with
output limitation between <i>0</i> and <i>1</i>.
The control output of this block is the product of these two control signals. Hence, there is
a continuous transition for intermediate values.
</p>
</html>", revisions="<html>
<ul>
<li>
September 17, 2016, by Michael Wetter:<br/>
Corrected quantity from <code>Temperature</code> to <code>ThermodynamicTemperature</code>
to avoid an error in the pedantic model check in Dymola 2017 FD01 beta2.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/557\">issue 557</a>.
</li>
<li>
September 11, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-118,58},{-42,26}},
          textColor={0,0,127},
          textString="T"),
        Text(
          extent={{-118,-24},{-42,-56}},
          textColor={0,0,127},
          textString="H"),
        Text(
          extent={{42,22},{118,-10}},
          textColor={0,0,127},
          textString="u")}));
end ElectrochromicWindow;
