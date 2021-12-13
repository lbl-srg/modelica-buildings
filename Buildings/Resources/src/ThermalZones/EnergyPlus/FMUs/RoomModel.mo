within ;
model RoomModel "Model of a thermal zones"

  parameter Modelica.Units.SI.Time samplePeriod(min=100*Modelica.Constants.eps, start=0.1) = 60
    "Sample period of component";

  parameter Modelica.Units.SI.Volume V "Volume";
  parameter Modelica.Units.SI.Area AFlo "Floor area";
  parameter Real mSenFac "Factor for scaling sensible thermal mass of volume";

  input Modelica.Units.NonSI.Temperature_degC T "Temperature of the zone air";
  input Real X(min=0, final unit="1") "Water vapor mass fraction in kg water/kg dry air";
  input Modelica.Units.SI.MassFlowRate mInlets_flow
     "Sum of positive mass flow rates into the zone for all air inlets (including infiltration)";
  input Modelica.Units.NonSI.Temperature_degC TAveInlet
    "Average of inlets medium temperatures carried by the mass flow rates";
  input Modelica.Units.SI.HeatFlowRate QGaiRad_flow
    "Radiative sensible heat gain added to the zone";

  discrete output Modelica.Units.NonSI.Temperature_degC TRad(start=20)
    "Average radiative temperature in the room";
  output Modelica.Units.SI.HeatFlowRate QConSen_flow
    "Convective sensible heat added to the zone";
  output Modelica.Units.SI.HeatFlowRate QLat_flow(start=-0.1)
    "Latent heat gain added to the zone";
  output Modelica.Units.SI.HeatFlowRate QPeo_flow
      "Heat gain due to people";
  discrete output Modelica.Units.NonSI.Temperature_degC TCon(start=20)
    "Construction temperature (first order approximation)";

protected
  parameter Modelica.Units.SI.Time startTime(fixed=false) "First sample time instant";
  parameter Modelica.Units.SI.Length h = V/AFlo "Room height";
  parameter Modelica.Units.SI.Area ACon = 2*AFlo + sqrt(AFlo)*h*4 "Surface area of constructions";
  parameter Modelica.Units.SI.ThermalConductance Ah = ACon * 8 "Conductance A*h for all surfaces";
  parameter Modelica.Units.SI.HeatCapacity CCon = ACon*0.2*800*2000 "Heat capacity of constructions";

  output Boolean sampleTrigger "True, if sample time instant";

  discrete Modelica.Units.SI.Time tLast "Time when state was updated the last time";
  discrete Modelica.Units.SI.Time tNext "Next requested sampling time";
  discrete Modelica.Units.NonSI.Temperature_degC TLast "Temperature of the zone air";
  discrete Real XLast(min=0, final unit="1") "Water vapor mass fraction in kg water/kg dry air";
  discrete Modelica.Units.SI.MassFlowRate mInlets_flowLast
     "Sum of positive mass flow rates into the zone for all air inlets (including infiltration)";
  discrete Modelica.Units.NonSI.Temperature_degC TAveInletLast
    "Average of inlets medium temperatures carried by the mass flow rates";
  discrete Modelica.Units.SI.HeatFlowRate QGaiRad_flowLast
    "Radiative sensible heat gain added to the zone";
  discrete Modelica.Units.NonSI.Temperature_degC TConLast(start=20)
    "Construction temperature (first order approximation)";

  pure function newInput "Function that outputs true if the xCur and xPre have different values"
  input Real xCur[:] "Current input";
  input Real xPre[:] "Previous input";
  output Boolean inputChanged "True if the input changed, false otherwise";
  protected
   Integer n = 1 "Dimension of input";
  algorithm
  inputChanged := false;
  for i in 1:n loop
    if abs(xCur[i]-xPre[i]) > 1E-10 then
      inputChanged := true;
      break;
    end if;
  end for;
  end newInput;

initial equation
  startTime = time;
  assert(false, "*** Test warning written by " + getInstanceName() + ".\n", AssertionLevel.warning);
equation
  sampleTrigger = sample(startTime, samplePeriod);

  when initial() then
    tLast = startTime;
    tNext = time + samplePeriod;
    TConLast = 20;
    TCon = 20;

    TRad = TCon;
    TLast = T;
    XLast = X;
    mInlets_flowLast = mInlets_flow;
    QGaiRad_flowLast = QGaiRad_flow;
    TAveInletLast = TAveInlet;
  elsewhen (time >= pre(tNext)) then
    // Time advanced.
    tLast = pre(tLast);
    tNext = time + samplePeriod;
    TConLast = pre(TCon);
    TCon = TConLast + (tLast-time) / CCon * (QConSen_flow +  QGaiRad_flow);

    TRad = TCon;
    TLast = T;
    XLast = X;
    mInlets_flowLast = mInlets_flow;
    QGaiRad_flowLast = QGaiRad_flow;
    TAveInletLast = TAveInlet;
  elsewhen newInput(
    {T, X, mInlets_flow, QGaiRad_flow, TAveInlet},
    {pre(TLast), pre(XLast), pre(mInlets_flowLast), pre(QGaiRad_flowLast), pre(TAveInletLast)}) then
    // Time did not advance but inputs changed
    tLast = pre(tLast);
    tNext = pre(tNext);
    TConLast = pre(TConLast);
    TCon = TConLast + (tLast-time) / CCon * (QConSen_flow +  QGaiRad_flow);

    TRad = TCon;
    TLast = T;
    XLast = X;
    mInlets_flowLast = mInlets_flow;
    QGaiRad_flowLast = QGaiRad_flow;
    TAveInletLast = TAveInlet;
    end when;

  QConSen_flow = Ah * (TCon-T);
  QLat_flow = 0;
  QPeo_flow = 0;
  annotation (Documentation(info="<html>
<p>
Simple room model that is used for testing the Spawn of EnergyPlus coupling.
</p>
</html>"));
end RoomModel;
