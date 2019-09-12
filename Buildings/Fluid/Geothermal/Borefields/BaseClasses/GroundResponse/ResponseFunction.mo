within Buildings.Fluid.Geothermal.Borefields.BaseClasses.GroundResponse;
model ResponseFunction

  parameter Integer nSeg
    "Number of segments to use in vertical discretization of the boreholes";
  parameter Real C = 1e7
    "Lump thermal capacity";
  parameter Real G = 5
    "Lumped thermal conductance";
  parameter Boolean steadyStateInitial=false
    "true initializes T with dT(0)/dt=0, false initializes T with T(0)=TIndHea_nominal";

  Modelica.Blocks.Interfaces.RealInput QBor_flow[nSeg](
    final unit=fill("W", nSeg))
    "Heat flow from boreholes (positive if heat from fluid into soil)"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput TExt_start[nSeg](
    final unit=fill("K", nSeg),
    displayUnit=fill("degC", nSeg),
    quantity=fill("ThermodynamicTemperature", nSeg))
    "Initial far field ground temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealOutput TBorWal[nSeg](
    final unit=fill("K", nSeg),
    displayUnit=fill("degC", nSeg),
    quantity=fill("ThermodynamicTemperature", nSeg))
    "Temperature of current borehole wall temperature"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-10},{120,10}})));

equation
   TBorWal = Buildings.Fluid.Geothermal.Borefields.BaseClasses.GroundResponse.Functions.GroundResponse(
      C, G, steadyStateInitial, QBor_flow, TExt_start);

annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,30},{100,-100}},
          lineColor={0,0,0},
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,30},{-94,-100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-66,-4},{72,-4}},
          color={255,0,0},
          arrow={Arrow.None,Arrow.Filled}),
        Rectangle(
          extent={{-100,30},{-94,-100}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,147},{149,107}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
            textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=
           false)));
end ResponseFunction;
