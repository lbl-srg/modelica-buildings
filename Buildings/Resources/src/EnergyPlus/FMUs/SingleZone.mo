within ;
model SingleZone "Model of a thermal zone"
  parameter Modelica.SIunits.Time samplePeriod(min=100*Modelica.Constants.eps, start=0.1) = 15*60
    "Sample period of component";

  parameter Modelica.SIunits.Volume V = 3*4*3 "Volume";
  parameter Modelica.SIunits.Area AFlo = 3*4 "Floor area";
  parameter Real mSenFac = 1 "Factor for scaling sensible thermal mass of volume";

  input Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T "Temperature of the zone air";
  input Real X "Water vapor mass fraction per total air mass of zone";
  input Modelica.SIunits.MassFlowRate mInlets_flow
     "Sum of positive mass flow rates into the zone for all air inlets (including infiltration)";
  input Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TInlet
    "Average of inlets medium temperatures carried by the mass flow rates";
  input Modelica.SIunits.HeatFlowRate QGaiRad_flow
    "Radiative sensible heat gain added to the zone";


  output Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TRad
    "Average radiative temperature in the room";
  output Modelica.SIunits.HeatFlowRate QConSen_flow
    "Convective sensible heat added to the zone";
  output Modelica.SIunits.HeatFlowRate QLat_flow
    "Latent heat gain added to the zone";
  output Modelica.SIunits.HeatFlowRate QPeo_flow
    "Heat gain due to people";

protected
  parameter Modelica.SIunits.Time startTime(fixed=false) "First sample time instant";

  output Boolean sampleTrigger "True, if sample time instant";
  output Boolean firstTrigger(start=false, fixed=true)
    "Rising edge signals first sample instant";

initial equation
  startTime = time;

equation
  sampleTrigger = sample(startTime, samplePeriod);
  when sampleTrigger then
    firstTrigger = time <= startTime + samplePeriod/2;
  end when;
 when {sampleTrigger, initial()} then
   TRad = 22;
   QConSen_flow = 500;
   QLat_flow = 400;
   QPeo_flow = 200;
 end when;

end SingleZone;