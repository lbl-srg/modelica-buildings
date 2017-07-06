within Buildings.Experimental.ScalableModels.ThermalZones.BaseClasses;
model MultiZoneFluctuatingIHG "Multiple thermal zone models"

  package MediumA = Buildings.Media.Air "Medium model";

  parameter Integer nZon(min=1) = 1 "Number of zones per floor"
    annotation(Evaluate=true);
  parameter Integer nFlo(min=1) = 1 "Number of floors"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.Angle lat=41.98*3.14159/180 "Latitude";

  parameter Real ampFactor[nZon]=
    if nZon<=5 then
        {abs(cos(i*3.1415926/(nZon))) for i in 1:nZon}
    else
        {abs(cos(i*3.1415926/5)) for i in 1:nZon}
    "IHG fluctuating amplitude factor";
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsIn[nZon,nFlo](
      redeclare each package Medium = MediumA) "Fluid inlets"
    annotation (Placement(transformation(extent={{-18,-76},{20,-66}}),
        iconTransformation(extent={{-18,-76},{20,-66}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsOut[nZon,nFlo](
      redeclare each package Medium = MediumA) "Fluid outlets"
    annotation (Placement(transformation(extent={{-22,50},{14,60}}),
        iconTransformation(extent={{-17,64},{19,74}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAir[nZon,nFlo] "Room air temperatures"
    annotation (Placement(transformation(extent={{100,-66},{120,-46}}),
        iconTransformation(extent={{100,-66},{120,-46}})));
  Modelica.Blocks.Interfaces.RealOutput heaCooPow[nZon,nFlo] "HVAC power"
    annotation (Placement(transformation(extent={{100,54},{120,74}}),
        iconTransformation(extent={{100,54},{120,74}})));
  BaseClasses.ThermalZoneFluctuatingIHG_WithPorts theZon[nZon, nFlo](
    redeclare each package MediumA = MediumA,
    each final lat=lat,
    gainFactor={{ampFactor[i] for j in 1:nFlo} for i in 1:nZon})  "Thermal zone model"
    annotation (Placement(transformation(extent={{-18,-18},{18,18}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus  "Weather data bus"
    annotation (Placement(transformation(extent={{-92,-10},{-72,10}}),
        iconTransformation(extent={{-92,-10},{-72,10}})));

equation
  for iZon in 1:nZon-1 loop
    for iFlo in 1:nFlo-1 loop
      connect(theZon[iZon, iFlo].heaPorFlo, theZon[iZon,
          if iFlo == nFlo then 1 else iFlo+1].heaPorCei)
        annotation (Line(
          points={{0,-18.36},{0,-20},{10,-20},{10,20},{0,20},{0,18}},
          color={191,0,0}));
      connect(theZon[iZon, iFlo].heaPorWal1, theZon[if iZon == nZon then 1
          else iZon+1, iFlo].heaPorWal2)
        annotation (Line(
          points={{-18,-2.88},{-18,-2.88},{-18,24},{12.36,24},{12.36,0},{18.36,0}},
          color={191,0,0}));
    end for;
  end for;
  for iZon in 1:nZon loop
    for iFlo in 1:nFlo loop
      connect(weaBus, theZon[iZon, iFlo].weaBus)
        annotation (Line(
          points={{-82,0},{-44,0},{-44,-14.4},{-13.32,-14.4}},
          color={255,204,51},
          thickness=0.5));
      connect(portsIn[iZon, iFlo], theZon[iZon, iFlo].portsInOut[1])
        annotation (Line(
          points={{1,-71},{-14.04,-71},{-14.04,4.32}},
          color={0,127,255},
          thickness=0.25));
      connect(portsOut[iZon, iFlo], theZon[iZon, iFlo].portsInOut[2])
        annotation (Line(
          points={{-4,55},{-10.44,55},{-10.44,4.32}},
          color={0,127,255},
          thickness=0.25));
      connect(TRooAir[iZon, iFlo], theZon[iZon, iFlo].TRooAir)
        annotation (Line(
          points={{110,-56},{38,-56},{38,6},{16,6},{18.36,6},{18.36,6.48}},
          color={0,0,0},
          thickness=0.25));
      connect(heaCooPow[iZon, iFlo], theZon[iZon, iFlo].heaCooPow)
        annotation (Line(
          points={{110,64},{36,64},{36,10},{16,10},{18.36,10},{18.36,10.08}},
          color={0,0,0},
          thickness=0.25));
    end for;
  end for;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-25,-25},{25,25}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={-39,-1},
          rotation=90),
        Rectangle(
          extent={{-58,18},{-20,-20}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{-25,-25},{25,25}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={41,-1},
          rotation=90),
        Rectangle(
          extent={{22,18},{60,-20}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Line(
          points={{-12,0},{14,0},{14,0}},
          color={95,95,95},
          pattern=LinePattern.DashDot),
        Line(points={{-14,52},{-34,22},{-152,104}}, pattern=LinePattern.None),
        Line(points={{-40,38},{40,38},{40,24}}, color={85,170,255}),
        Line(points={{-40,38},{-40,24}}, color={85,170,255}),
        Line(points={{0,64},{0,38}}, color={85,170,255}),
        Line(points={{-40,-40},{42,-40}}, color={85,170,255}),
        Line(points={{-40,-40},{-40,-26}}, color={85,170,255}),
        Line(points={{42,-40},{42,-26}}, color={0,0,0}),
        Line(points={{2,-66},{2,-40}}, color={85,170,255}),
        Line(
          points={{0,38}},
          color={95,95,95},
          pattern=LinePattern.DashDot,
          thickness=0.5),
        Line(points={{0,38},{0,22}}, color={85,170,255}),
        Line(points={{2,-40},{2,-26}}, color={85,170,255}),
        Text(
          extent={{-100,126},{100,100}},
          lineColor={0,0,255},
          textString="Multizone model with: %nZon zones in %nZon floors")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model groups multiple zones by linking their neighbor walls and floor/ceiling.
The factor <code>ampFactor</code> controls the fluctuating amplitude 
of internal heat gain in each zone.  
</p>

</html>", revisions="<html>
<ul>
<li>
April 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end MultiZoneFluctuatingIHG;
