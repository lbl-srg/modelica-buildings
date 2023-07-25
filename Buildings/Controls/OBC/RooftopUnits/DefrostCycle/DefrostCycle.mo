within Buildings.Controls.OBC.RooftopUnits.DefrostCycle;
block DefrostCycle
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput EleHeaCom(
    final min=0,
    final max=1,
    final unit="1") if have_heaCoi "Electric heater command" annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(
          extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCoiSur(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured coil surface temperature"
                                      annotation (Placement(transformation(
          extent={{-140,-60},{-100,-20}}),
                                         iconTransformation(extent={{-140,-60},
            {-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCoiSurSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Predefined coil surface temperature setpoint" annotation (Placement(
        transformation(extent={{-140,-100},{-100,-60}}),iconTransformation(
          extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput OutFanCom(
    final min=0,
    final max=1,
    final unit="1") "Outdoor fan commanded speed" annotation (Placement(
        transformation(extent={{100,20},{140,60}}), iconTransformation(extent=
           {{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutLoc(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Predefined outdoor lockout temperature setpoint" annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}), iconTransformation(
          extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoiAva[nCoi]
    "DX coil current availability status vector" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOpeMod[nCoi]
    "DX coil operation mode" annotation (Placement(transformation(extent={{100,-60},
            {140,-20}}),          iconTransformation(extent={{100,-60},{140,
            -20}})));

  annotation (
    defaultComponentName="DefCyc",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
        graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,100},{100,100}},
            textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end DefrostCycle;
