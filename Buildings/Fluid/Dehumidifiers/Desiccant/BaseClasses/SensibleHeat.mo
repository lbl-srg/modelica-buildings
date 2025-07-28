within Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses;
model SensibleHeat
  "Sensible heat exchange during the dehumidification process"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput hPro(final unit="J/kg")
    "Vaporization enthalpy of water in process air"
    annotation (Placement(transformation(extent={{-124,68},{-100,92}}),
    iconTransformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput mPro_flow(
    final unit="kg/s")
    "Mass flow rate of the process air"
    annotation (Placement(transformation(extent={{-124,28},{-100,52}}),
    iconTransformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput X_w_ProEnt(final unit="kg/kg")
    "Humidity ratio of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-124,-12},{-100,12}}),
    iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput X_w_ProLea(final unit="1")
    "Humidity ratio of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-124,-52},{-100,-28}}),
    iconTransformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput hReg(final unit="J/kg")
    "Regeneration specific energy"
    annotation (Placement(transformation(extent={{-124,-92},{-100,-68}}),
    iconTransformation(extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.Interfaces.RealOutput Q(final unit="W")
    "Specific regeneration power"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
    iconTransformation(extent={{100,-10},{120,10}})));
equation
  Q = mPro_flow*(X_w_ProEnt - X_w_ProLea)*(hReg - hPro);
  annotation (
  defaultComponentName="senHea",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-80,-6},{-50,-46}},
          textColor={0,0,88},
          textString="T1"),
        Text(
          extent={{42,62},{72,22}},
          textColor={0,0,88},
          textString="T2"),
        Line(points={{-34,-38},{-34,-6},{-40,-6},{-34,10}},
        color={28,108,200},
          thickness=0.5),
        Line(
          points={{-34,10},{-28,-6},{-36,-6}},
          color={28,108,200},
          thickness=0.5),
        Line(points={{34,44},{34,12},{28,12},{34,-6}},
        color={28,108,200},
          thickness=0.5),
        Line(
          points={{34,-6},{42,12},{34,12}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{24,6},{-16,6},{-6,0}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-16,6},{-6,12}},
          color={28,108,200},
          thickness=0.5)}),                          Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model analyzes the sensible heat exchange between the process air and the regeneration air in a desiccant dehumidifier.
</p>
Specifically, it calculates the sensible heat exchange rate, <code>Q</code>, by:
<p align=\"center\" style=\"font-style:italic;\">
Q = (X_w_ProEnt-X_w_ProLea)*mPro_flow*(hReg-hPro),
</p>
where <code>X_w_ProEnt</code> and <code>X_w_ProLea</code> are the humidity ratio of the process air entering and leaving 
the dehumidifier, respectively.
<code>mPro_flow</code> is the mass flow rate of the process air.
<code>hReg</code> is the specific heat of the regeneration (see <a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance\"> 
Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance</a>).
<code>hPro</code> is the vaporization enthalpy of water in process air.
</html>", revisions="<html>
<ul>
<li>July 17, 2025, by Sen Huang:<br/>
First implementation.</li>
</ul>
</html>"));
end SensibleHeat;
