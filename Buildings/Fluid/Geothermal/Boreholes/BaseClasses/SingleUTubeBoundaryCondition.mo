within Buildings.Fluid.Geothermal.Boreholes.BaseClasses;
model SingleUTubeBoundaryCondition
  "Prescribed temperature at the outer boundary of a single U tube borehole"
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic matSoi
    "Thermal properties of the soil"
     annotation (choicesAllMatching=true);
  parameter Modelica.Units.SI.Radius rExt=3
    "Distance from the brine where the calculation is performed";
  parameter Modelica.Units.SI.Height hSeg=10 "Height of the segment";
  parameter Modelica.Units.SI.Temperature TExt_start=283.15
    "Initial external temperature";
  parameter Modelica.Units.SI.Time samplePeriod=604800
    "Period between two samples";
  ExtendableArray table=ExtendableArray()
    "Extentable array, used to store history of rate of heat flows";
  Modelica.Units.SI.HeatFlowRate QAve_flow
    "Average heat flux over a time period";
  Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
    "Heat flow rate at the center of the borehole, positive if heat is added to soil"
     annotation (Placement(transformation(extent={{-120,-100},{-80,-60}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port "Heat port"
    annotation (Placement(transformation(extent={{86,-10},
            {106,10}}), iconTransformation(extent={{86,-10},
            {106,10}})));
protected
  final parameter Modelica.Units.SI.SpecificHeatCapacity c=matSoi.c
    "Specific heat capacity of the soil";
  final parameter Modelica.Units.SI.ThermalConductivity k=matSoi.k
    "Thermal conductivity of the soil";
  final parameter Modelica.Units.SI.Density d=matSoi.d "Density of the soil";
  Modelica.Units.SI.Energy UOld "Internal energy at the previous period";
  Modelica.Units.SI.Energy U
    "Current internal energy, defined as U=0 for t=tStart";
  final parameter Modelica.Units.SI.Time startTime(fixed=false)
    "Start time of the simulation";
  Integer iSam(min=1)
    "Counter for how many time the model was sampled. Defined as iSam=1 when called at t=0";
initial equation
  U         = 0;
  UOld      = 0;
  startTime = time;
  iSam      = 1;
  port.T    = TExt_start;
  QAve_flow = 0;
equation
  der(U) = Q_flow;

  when sample(startTime, samplePeriod) then
    QAve_flow = (U-pre(UOld))/samplePeriod;
    UOld      = U;
    port.T    = TExt_start + Buildings.Fluid.Geothermal.Boreholes.BaseClasses.temperatureDrop(
                                 table=table, iSam=pre(iSam),
                                 Q_flow=QAve_flow, samplePeriod=samplePeriod,
                                 rExt=rExt, hSeg=hSeg,
                                 k=k, d=d, c=c);
    iSam = pre(iSam)+1;
  end when;

annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={159,159,223},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-102,0},{64,0}},
          color={191,0,0},
          thickness=0.5),
        Text(
          extent={{0,0},{-100,-100}},
          textColor={0,0,0},
          textString="K"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Polygon(
          points={{40,-18},{40,22},{80,2},{40,-18}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}),
          Documentation(info="<html>
<p>
This model computes the temperature boundary condition at the outer boundary of the borehole.
It takes as an input the heat flow rate at the center of the borehole.
This heat flow rate is averaged over the sample period.
At each sampling interval, typically every one week, a new temperature boundary conditions is computed using
the analytical solution to a line source heat transfer problem.
</p>
<h4>Implementation</h4>
<p>
The computation of the temperature change of the boundary is computed using the function
<a href=\"modelica://Buildings.Fluid.Geothermal.Boreholes.BaseClasses.temperatureDrop\">
Buildings.Fluid.Geothermal.Boreholes.BaseClasses.temperatureDrop</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 26, 2018, by Michael Wetter:<br/>
Replaced <code>algorithm</code> with <code>equation</code>.
</li>
<li>
June 9, 2015 by Michael Wetter:<br/>
Revised model to provide start values and avoid a warning if
<a href=\"modelica://Buildings.Fluid.Geothermal.Boreholes.Examples.UTube\">
Buildings.Fluid.Geothermal.Boreholes.Examples.UTube</a>
is translated
using pedantic mode in Dymola 2016.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">#426</a>.
</li>
<li>
September 27, 2013, by Michael Wetter:<br/>
Moved assignment of <code>startTime</code> to <code>initial algorithm</code> section
to avoid an error in OpenModelica.
</li>
<li>
November 3 2011, by Michael Wetter:<br/>
Moved <code>der(U) := Q_flow;</code> from the algorithm section to the equation section
as this assignment does not conform to the Modelica specification.
</li>
<li>
September 9 2011, by Michael Wetter:<br/>
Moved <code>equation</code> section into <code>algorithm</code> section to make sure that the equations
in the <code>when</code> block are ordered correctly.
</li>
<li>
July 28 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleUTubeBoundaryCondition;
