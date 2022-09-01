within Buildings.Fluid.Geothermal.Boreholes.BaseClasses;
function temperatureDrop
  "Calculate the temperature drop of the soil at the external boundary of the cylinder"
input ExtendableArray table
    "External object that contains the history terms of the heat flux";
input Integer iSam(min=1)
    "Counter for how many time the model was sampled. Defined as iSam=1 when called at t=0";

  input Modelica.Units.SI.HeatFlowRate Q_flow
    "Heat flow rate to be stored in the external object";
  input Modelica.Units.SI.Time samplePeriod "Period between two samples";
  input Modelica.Units.SI.Radius rExt "External radius of the cylinder";
  input Modelica.Units.SI.Height hSeg "Height of the cylinder";
  input Modelica.Units.SI.ThermalConductivity k
    "Thermal conductivity of the soil";
  input Modelica.Units.SI.Density d "Density of the soil";
  input Modelica.Units.SI.SpecificHeatCapacity c
    "Specific heat capacity of the soil";
  output Modelica.Units.SI.TemperatureDifference dT
    "Temperature drop of the soil";
protected
  Modelica.Units.SI.Time minSamplePeriod=rExt^2/(4*(k/c/d)*3.8)
    "Minimal length of the sampling period";
  Modelica.Units.SI.HeatFlowRate QL_flow
    "Intermediate variable for heat flow rate at the lower bound of the time interval";
  Modelica.Units.SI.HeatFlowRate QU_flow
    "Intermediate variable for heat flow rate at the upper bound of the time interval";

algorithm
  assert(rExt*rExt/(4*(k/c/d)*samplePeriod)<=3.8,
  "The samplePeriod has to be bigger than " + String(minSamplePeriod) + " for convergence purpose.
  samplePeriod = "+ String(samplePeriod));
  if iSam == 1 then
    // First call, at t=0
    dT := 0;
    QL_flow := Buildings.Fluid.Geothermal.Boreholes.BaseClasses.exchangeValues(
                       table=table, iX=iSam, x=Q_flow, iY=iSam);
  else
    dT := 0;
    // The first evaluation is at iSam=2, in which case we have one term of the sum,
    // and t=samplePeriod=(iSam-1)*samplePeriod
   for i in 1:(iSam-1) loop
      QL_flow := Buildings.Fluid.Geothermal.Boreholes.BaseClasses.exchangeValues(
        table=table, iX=iSam, x=Q_flow, iY=iSam+1-i);
      QU_flow := Buildings.Fluid.Geothermal.Boreholes.BaseClasses.exchangeValues(
        table=table, iX=iSam, x=Q_flow, iY=iSam-i);
      // The division by hSeg is because QU_flow and QL_flow are in [W], but the equation
      // requires [W/m], i.e., heat flow rate per unit length of the line source.
      dT := dT + 1/(4*Modelica.Constants.pi*k)*
        Buildings.Fluid.Geothermal.Boreholes.BaseClasses.powerSeries(
           u=c*d/(4*k*i*samplePeriod)*rExt^2, N=10)*
        (QL_flow-QU_flow)/hSeg;
 end for;
  end if;
annotation(Documentation(info="<html>
<p>
This function calculates the temperature drop of the soil at the outer boundary of the cylinder.
The analytical formula of Hart and Couvillion (1986) for constant
heat extraction is adapted to a non-constant heat flux.
To adapt the formula for a variable rate of heat extraction,
different constant heat extraction rates, starting at different time instances,
are super-imposed.
To obtain the temperature drop at the time <i>t=n*&Delta;t</i>, the effects of
constant rate of heat extractions are super-imposed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Delta;T ( r , t=n &Delta;t )= 1 &frasl; ( 4 &pi; k )
  &sum;  W(u(r, t= i &Delta;t)) (q<sub>n-i+1</sub>-q<sub>n-i</sub>),
</p>
<p>
where <i>r</i> is the radius for which the temperature is computed,
<i>k</i> is the thermal conductivity of the material,
<i>W</i> is a solution of the heat conduction in polar coordinates and
<i>q<sub>i</sub>=Q<sub>i</sub>/h</i> is
the specific rate of heat extraction per unit length at time
<i>t=i &Delta;t</i>.
The value of
<i>W</i> is obtained using
</p>
<p align=\"center\" style=\"font-style:italic;\">
W(u)=[-0.5772 - ln(u) + u - u<sup>2</sup>/(2 &nbsp; 2!) +u<sup>3</sup>/(3 &nbsp; 3!) - u<sup>4</sup>/(4 &nbsp; 4!) + ....].
</p>
<p>
where
<i>u(r,t)= c &rho; r<sup>2</sup> &frasl; (4 t k) </i>,
<i>&rho;</i> is the mass density and
<i>c</i> is the specific heat capacity per unit mass.
</p>
<h4>Implementation</h4>
<p>
The rate of heat flow <i>Q<sub>i</sub></i> is obtained from the function
<a href=\"modelica://Buildings.Fluid.Geothermal.Boreholes.BaseClasses.exchangeValues\">
Buildings.Fluid.Geothermal.Boreholes.BaseClasses.exchangeValues</a>.
</p>
<h4>References</h4>
<p>
Hart and Couvillion, (1986). <i>Earth Coupled Heat Transfer.</i>
Publication of the National Water Well Association.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 27, 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end temperatureDrop;
