within ;
model Zones3 "Model of three thermal zones"

  parameter Modelica.SIunits.Time samplePeriod(min=100*Modelica.Constants.eps, start=0.1) = 60
    "Sample period of component";

  parameter output Modelica.SIunits.Volume Core_ZN_V = 3*4*3 "Volume";
  parameter output Modelica.SIunits.Area Core_ZN_AFlo = 3*4 "Floor area";
  parameter output Real Core_ZN_mSenFac = 1 "Factor for scaling sensible thermal mass of volume";
  //parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Core_ZN_T_start = 20
  //  "Initial temperature of zone air";

  parameter output Modelica.SIunits.Volume South_ZN_V = 3*4*3 "Volume";
  parameter output Modelica.SIunits.Area South_ZN_AFlo = 3*4 "Floor area";
  parameter output Real South_ZN_mSenFac = 1 "Factor for scaling sensible thermal mass of volume";
  //parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC South_ZN_T_start = 20
  //  "Initial temperature of zone air";

  parameter output Modelica.SIunits.Volume North_ZN_V = 3*4*3 "Volume";
  parameter output Modelica.SIunits.Area North_ZN_AFlo = 3*4 "Floor area";
  parameter output Real North_ZN_mSenFac = 1 "Factor for scaling sensible thermal mass of volume";
  //parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC North_ZN_T_start = 20
  //  "Initial temperature of zone air";

  input Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Core_ZN_T "Temperature of the zone air";
  input Real Core_ZN_X(min=0, final unit="1") "Water vapor mass fraction in kg water/kg dry air";
  input Modelica.SIunits.MassFlowRate Core_ZN_mInlets_flow
     "Sum of positive mass flow rates into the zone for all air inlets (including infiltration)";
  input Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Core_ZN_TAveInlet
    "Average of inlets medium temperatures carried by the mass flow rates";
  input Modelica.SIunits.HeatFlowRate Core_ZN_QGaiRad_flow
    "Radiative sensible heat gain added to the zone";

  input Modelica.SIunits.Conversions.NonSIunits.Temperature_degC South_ZN_T "Temperature of the zone air";
  input Real South_ZN_X(min=0, final unit="1") "Water vapor mass fraction in kg water/kg dry air";
  input Modelica.SIunits.MassFlowRate South_ZN_mInlets_flow
     "Sum of positive mass flow rates into the zone for all air inlets (including infiltration)";
  input Modelica.SIunits.Conversions.NonSIunits.Temperature_degC South_ZN_TAveInlet
    "Average of inlets medium temperatures carried by the mass flow rates";
  input Modelica.SIunits.HeatFlowRate South_ZN_QGaiRad_flow
    "Radiative sensible heat gain added to the zone";

  input Modelica.SIunits.Conversions.NonSIunits.Temperature_degC North_ZN_T "Temperature of the zone air";
  input Real North_ZN_X(min=0, final unit="1") "Water vapor mass fraction in kg water/kg dry air";
  input Modelica.SIunits.MassFlowRate North_ZN_mInlets_flow
     "Sum of positive mass flow rates into the zone for all air inlets (including infiltration)";
  input Modelica.SIunits.Conversions.NonSIunits.Temperature_degC North_ZN_TAveInlet
    "Average of inlets medium temperatures carried by the mass flow rates";
  input Modelica.SIunits.HeatFlowRate North_ZN_QGaiRad_flow
    "Radiative sensible heat gain added to the zone";


  discrete output Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Core_ZN_TRad
    "Average radiative temperature in the room";
  output Modelica.SIunits.HeatFlowRate Core_ZN_QConSen_flow
    "Convective sensible heat added to the zone";
  output Modelica.SIunits.HeatFlowRate Core_ZN_QLat_flow(start=-0.1)
    "Latent heat gain added to the zone";
  output Modelica.SIunits.HeatFlowRate Core_ZN_QPeo_flow
      "Heat gain due to people";
  discrete output Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Core_TCon(start=20) "Construction temperature (first order approximation)";

  discrete output Modelica.SIunits.Conversions.NonSIunits.Temperature_degC South_ZN_TRad
    "Average radiative temperature in the room";
  output Modelica.SIunits.HeatFlowRate South_ZN_QConSen_flow
    "Convective sensible heat added to the zone";
  output Modelica.SIunits.HeatFlowRate South_ZN_QLat_flow(start=0.1)
    "Latent heat gain added to the zone";
  output Modelica.SIunits.HeatFlowRate South_ZN_QPeo_flow
      "Heat gain due to people";
  discrete output Modelica.SIunits.Conversions.NonSIunits.Temperature_degC South_TCon(start=20) "Construction temperature (first order approximation)";

  discrete output Modelica.SIunits.Conversions.NonSIunits.Temperature_degC North_ZN_TRad
    "Average radiative temperature in the room";
  output Modelica.SIunits.HeatFlowRate North_ZN_QConSen_flow
    "Convective sensible heat added to the zone";
  output Modelica.SIunits.HeatFlowRate North_ZN_QLat_flow(start=0.1)
    "Latent heat gain added to the zone";
  output Modelica.SIunits.HeatFlowRate North_ZN_QPeo_flow
      "Heat gain due to people";
  discrete output Modelica.SIunits.Conversions.NonSIunits.Temperature_degC North_TCon(start=20) "Construction temperature (first order approximation)";

protected
  parameter Modelica.SIunits.Time startTime(fixed=false) "First sample time instant";
  parameter Modelica.SIunits.Area ACon = (2*6*6+4*6*2.7) "Surface area of constructions";
  parameter Modelica.SIunits.Conductance Ah = ACon * 8 "Conductance A*h for all surfaces";
  parameter Modelica.SIunits.HeatCapacity CCon = ACon*0.2*800*2000 "Heat capacity of constructions";

  output Boolean sampleTrigger "True, if sample time instant";
  output Boolean firstTrigger(start=false, fixed=true)
    "Rising edge signals first sample instant";

initial equation
  startTime = time;

  Core_TCon = 20;
  South_TCon = 20;
  North_TCon = 20;
  Modelica.Utilities.Files.removeFile("TestModelOutput.txt");
equation
  sampleTrigger = sample(startTime, samplePeriod);

  when sampleTrigger then
    firstTrigger = time <= startTime + samplePeriod/2;
  end when;

  when {sampleTrigger} then
    if not initial() then
      Core_TCon  = pre(Core_TCon) +  0*samplePeriod / CCon * (Core_ZN_QConSen_flow +  Core_ZN_QGaiRad_flow);
      South_TCon = pre(South_TCon) + 0*samplePeriod / CCon * (South_ZN_QConSen_flow + South_ZN_QGaiRad_flow);
      North_TCon = pre(North_TCon) + 0*samplePeriod / CCon * (North_ZN_QConSen_flow + North_ZN_QGaiRad_flow);
    else
      Core_TCon  = pre(Core_TCon);
      South_TCon = pre(South_TCon);
      North_TCon = pre(North_TCon);
    end if;

    Core_ZN_TRad = pre(Core_ZN_T);

    South_ZN_TRad = pre(South_ZN_T);

    North_ZN_TRad = pre(North_ZN_T);
    Modelica.Utilities.Streams.print("------ time = " + String(time)
      + " \t initial(), sampleTrigger = " + String(initial()) + ", " + String(sampleTrigger)
      + " \t {Core,South,North}_ZN_T = " + String(Core_ZN_T) + ", " + String(South_ZN_T) + ", " + String(North_ZN_T),
      "TestModelOutput.txt");
      //       + "\t {Core,South,North}_ZN_QConSen_flow = " + String(Core_ZN_QConSen_flow) + ", " + String(South_ZN_QConSen_flow) + ", " + String(North_ZN_QConSen_flow),
  end when;
    Modelica.Utilities.Streams.print("---+++ time = " + String(time)
      + " \t initial(), sampleTrigger = " + String(initial()) + ", " + String(sampleTrigger)
      + " \t {Core,South,North}_ZN_T = " + String(Core_ZN_T) + ", " + String(South_ZN_T) + ", " + String(North_ZN_T),
      "TestModelOutput.txt");

    Core_ZN_QConSen_flow = Ah * (Core_TCon-Core_ZN_T);
    Core_ZN_QLat_flow = 0;
    Core_ZN_QPeo_flow = 200;

    South_ZN_QConSen_flow = Ah * (South_TCon-South_ZN_T);
    South_ZN_QLat_flow = 0;
    South_ZN_QPeo_flow = 200;

    North_ZN_QConSen_flow = Ah * (North_TCon-North_ZN_T);
    North_ZN_QLat_flow = 0;
    North_ZN_QPeo_flow = 200;

end Zones3;
