within Buildings.Fluid.HeatPumps.BaseClasses;
block DOE2Method
  extends Modelica.Blocks.Icons.Block;

  parameter  Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per
   "Performance data"
     annotation (choicesAllMatching = true,Placement(transformation(
         extent={{80,80},{100,100}})));
  parameter Real SF
   "Load scale factor for heatpump";
  final parameter Modelica.SIunits.HeatFlowRate QCon_heatflow_nominal = -QEva_heatflow_nominal + P_nominal
   "Nominal heat flow at the condenser";
  final parameter Modelica.SIunits.HeatFlowRate QEva_heatflow_nominal= per.QEva_flow_nominal*SF
   "Reference capacity";
  final parameter Modelica.SIunits.Power P_nominal = QEva_heatflow_nominal/(per.COP_nominal)
   "Nominal power of the compressor";
  final parameter Modelica.SIunits.HeatFlowRate Q_flow_small = QCon_heatflow_nominal*1E-9
   "Small value for heat flow rate or power, used to avoid division by zero";
  Modelica.Blocks.Interfaces.RealInput TEvaSet(final unit="K", displayUnit="degC")
   "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-124,-112},{-100,-88}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));
  Modelica.Blocks.Interfaces.RealInput TConSet(final unit="K", displayUnit="degC")
   "Set point for leaving heating water temperature"
    annotation (Placement(transformation(extent={{-124,86},{-100,110}}),
        iconTransformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.IntegerInput uMod
   "HeatPump control input signal, Heating mode= 1, Off=0, Cooling mode=-1"
    annotation (Placement(transformation(extent={{-124,-12},{-100,12}}),
        iconTransformation(extent={{-120,-12},{-100,8}})));
  Modelica.Blocks.Interfaces.RealInput TConEnt(final unit="K", displayUnit="degC")
   "Condenser entering water temperature"
    annotation (Placement(transformation(extent={{-124,48},{-100,72}}),
        iconTransformation(extent={{-120,64},{-100,84}})));
  Modelica.Blocks.Interfaces.RealInput TEvaLvg(final unit="K", displayUnit="degC")
   "Evaporator leaving water temperature"
    annotation (Placement(transformation(extent={{-124,-72},{-100,-48}}),
        iconTransformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput QConFloSet(final unit="W")
   "Condenser setpoint heat flow rate"
    annotation (Placement(transformation(extent={{-124,28},{-100,52}}),
        iconTransformation(extent={{-120,12},{-100,32}})));
  Modelica.Blocks.Interfaces.RealInput QEvaFloSet(final unit="W")
   "Evaporator setpoint heat flow rate"
    annotation (Placement(transformation(extent={{-124,-52},{-100,-28}}),
        iconTransformation(extent={{-120,-36},{-100,-16}})));
  Modelica.Blocks.Interfaces.RealInput TConLvg(final unit="K", displayUnit="degC")
   "Condenser leaving water temperature"
    annotation (Placement(transformation(extent={{-124,66},{-100,90}}),
        iconTransformation(extent={{-120,38},{-100,58}})));
  Modelica.Blocks.Interfaces.RealInput TEvaEnt(final unit="K", displayUnit="degC")
   "Evaporator entering water temperature"
    annotation (Placement(transformation(extent={{-124,-92},{-100,-68}}),
        iconTransformation(extent={{-120,-84},{-100,-64}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(final unit="W")
   "Condenser heat flow rate "
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(final unit="W")
   "Evaporator heat flow rate"
    annotation (Placement(transformation(extent={{100,-48},{120,-28}}),
        iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
   "Compressor power"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.SIunits.Efficiency EIRFT(nominal=1)
   "Power input to ccoling capacity ratio function of temperature curve";
  Modelica.SIunits.Efficiency EIRFPLR(nominal=1)
   "Power input to cooling capacity ratio function of part load ratio";
  Real CapFT(min=0,nominal=1)
   "Cooling capacity factor function of temperature curve";
  Real PLR1(min=0, nominal=1, unit="1")
   "Part load ratio";
  Real PLR2(min=0, nominal=1, unit="1")
   "Part load ratio";
  Real CR(min=0, nominal=1, unit="1")
   "Cycling ratio";
  Modelica.SIunits.HeatFlowRate QCon_flow_ava
   "Heating capacity available at the condender";
  Modelica.SIunits.HeatFlowRate QEva_flow_ava
   "Cooling capacity available at the evaporator";
  Modelica.SIunits.Efficiency COP
   "Coefficient of performance";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TConEnt_degC
   "Condenser entering water temperature in degC";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TEvaLvg_degC
   "Evaporator leaving water temperature in degC";

initial equation
  assert(QCon_heatflow_nominal > 0,
  "Parameter QCon_flow_nominal must be larger than zero.");
  assert(QEva_heatflow_nominal < 0,
  "Parameter QEva_heatflow_nominal must be lesser than zero.");
  assert(Q_flow_small > 0,
  "Parameter Q_flow_small must be larger than zero.");
  assert(per.PLRMinUnl >= per.PLRMin,
  "Parameter PLRMinUnl must be bigger or equal to PLRMin");
  assert(per.PLRMax > per.PLRMinUnl,
  "Parameter PLRMax must be bigger than PLRMinUnl");

equation
  TConEnt_degC=Modelica.SIunits.Conversions.to_degC(TConEnt);
  TEvaLvg_degC=Modelica.SIunits.Conversions.to_degC( TEvaLvg);

  if (uMod==1) then

     CapFT  = Buildings.Utilities.Math.Functions.smoothMax(
         x1 = 1E-7,
         x2 = Buildings.Utilities.Math.Functions.biquadratic(
                                      a = per.capFunT,
                                     x1 = TEvaLvg_degC,
                                     x2 = TConEnt_degC),
                                         deltaX = 1E-7);

      EIRFT = Buildings.Utilities.Math.Functions.biquadratic(
                                      a = per.EIRFunT,
                                     x1 = TEvaLvg_degC,
                                     x2 = TConEnt_degC);

      EIRFPLR = per.EIRFunPLR[1]+per.EIRFunPLR[2]*PLR2+per.EIRFunPLR[3]*PLR2^2;

      QCon_flow_ava = QCon_heatflow_nominal*CapFT;
      QEva_flow_ava = 0;

      PLR1 = Buildings.Utilities.Math.Functions.smoothMax(
                              x1 =  QConFloSet/(QCon_flow_ava - Q_flow_small),
                              x2 =  per.PLRMax,
                          deltaX =  per.PLRMax/100);

      PLR2 = Buildings.Utilities.Math.Functions.smoothMax(
                              x1 =  per.PLRMinUnl,
                              x2 =  PLR1,
                          deltaX =  per.PLRMinUnl/100);

      CR = Buildings.Utilities.Math.Functions.smoothMin(
                              x1 =  PLR1/per.PLRMin,
                              x2 =  1,
                          deltaX =  0.001);

      P = (QCon_flow_ava/per.COP_nominal)*EIRFT*EIRFPLR*CR;
      QCon_flow = Buildings.Utilities.Math.Functions.smoothMin(
                              x1 = QConFloSet,
                              x2 = QCon_flow_ava,
                          deltaX = Q_flow_small/10);

      QEva_flow = -(QCon_flow - P*per.etaMotor);
      COP =QCon_flow/(P + Q_flow_small);

  elseif (uMod==-1) then

      CapFT = Buildings.Utilities.Math.Functions.smoothMax(
        x1 = 1E-6,
        x2 = Buildings.Utilities.Math.Functions.biquadratic(
                              a = per.capFunT,
                             x1 = TEvaLvg_degC,
                             x2 = TConEnt_degC),
                         deltaX = 1E-7);
      EIRFT = Buildings.Utilities.Math.Functions.biquadratic(
                              a = per.EIRFunT,
                             x1 = TEvaLvg_degC,
                             x2 = TConEnt_degC);

      EIRFPLR = per.EIRFunPLR[1]+per.EIRFunPLR[2]*PLR2+per.EIRFunPLR[3]*PLR2^2;

      QEva_flow_ava = QEva_heatflow_nominal*CapFT;
      QCon_flow_ava = 0;

      PLR1 =Buildings.Utilities.Math.Functions.smoothMin(
                            x1 =  QEvaFloSet/(QEva_flow_ava - Q_flow_small),
                            x2 =  per.PLRMax,
                        deltaX =  per.PLRMax/100);
      PLR2 = Buildings.Utilities.Math.Functions.smoothMax(
                            x1 =  per.PLRMinUnl,
                            x2 =  PLR1,
                        deltaX =  per.PLRMinUnl/100);
      CR = Buildings.Utilities.Math.Functions.smoothMin(
                            x1 =  PLR1/per.PLRMin,
                            x2 =  1,
                        deltaX =  0.001);

      P = (-QEva_flow_ava)/per.COP_nominal*EIRFT*EIRFPLR*CR;

      QEva_flow = Buildings.Utilities.Math.Functions.smoothMax(
                            x1 = QEvaFloSet,
                            x2 = QEva_flow_ava,
                        deltaX = Q_flow_small/10);

      QCon_flow = -QEva_flow + P*per.etaMotor;
      COP  =-QEva_flow/(P + Q_flow_small);

  else

     CapFT = 0;
     EIRFT = 0;
     EIRFPLR= 0;
     QEva_flow_ava = 0;
     QCon_flow_ava = 0;
     PLR1 = 0;
     PLR2 = 0;
     CR   = 0;
     QCon_flow = 0;
     QEva_flow = 0;
     P    = 0;
     COP = 0;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  defaultComponentName="doe2",
  Documentation(info="<html>
  <p>
  The Block includes the description of the DOE2 method dedicated for<a href=\"Buildings.Fluid.HeatPumps.DOE2WaterToWater\">
  Buildings.Fluid.HeatPumps.DOE2WaterToWater</a>.
  </p>
  <p>
  The block uses three functions to predict the thermal capacity and power consumption through three operational modes executed by a control input integer signal uMod=1 heating mode, uMod=-1 cooling mode and uMod=0 shutoff.
  </p>
  <ol>
  <li>
  The first function is <code>CapFT</code> the capacity function of temperature bi-quadratic curve
  <p align=\"center\" style=\"font-style:italic;\">
  CapFT = capFunT<sub>1</sub>+ capFunT<sub>2</sub>T<sub>Eva,Lvg</sub>+
  capFunT<sub>3</sub>T<sup>2</sup><sub>Eva,Lvg</sub>+ capFunT<sub>4</sub>T<sub>Con,Ent</sub>+capFunT<sub>5</sub>T<sup>2</sup><sub>Con,Ent</sub>
  +capFunT<sub>6</sub>T<sub>Con,Ent</sub>T<sub>Eva,Lvg</sub>
  <p>
  where the performance curve coefficients from <i>capFunT<sub>1</sub> to capFunT<sub>6</sub> </i>
  are stored in the data record <code>per</code>.
  </p>
  </li>
  <li>
  The second function is <code>EIRFT</code> the electric input to capacity output ratio function of temperature bi-quadratic curve
  <p align=\"center\" style=\"font-style:italic;\">
  EIRFT = EIRFunT<sub>1</sub>+ EIRFunT<sub>2</sub>T<sub>Eva,Lvg</sub>+
  EIRFunT<sub>3</sub>T<sup>2</sup><sub>Eva,Lvg</sub>+ EIRFunT<sub>4</sub>T<sub>Con,Ent</sub>+EIRFunT<sub>5</sub>T<sup>2</sup><sub>Con,Ent</sub>
  +EIRFunT<sub>6</sub>T<sub>Con,Ent</sub>T<sub>Eva,Lvg</sub>
  <p> 
  where the performance curve coefficients from <i>EIRFunT<sub>1</sub> to EIRFunT<sub>6</sub> </i>
  are stored in the data record <code>per</code>.
  </p>
  </li>
  <li>
  The third performance function is <code>EIRFPLR</code> the electric input to capacity output ratio function of part load ratio bi-cubic curve
  <p align=\"center\" style=\"font-style:italic;\">
  EIRFPLR = EIRFunPLR<sub>1</sub>+ EIRFunPLR<sub>2</sub>PLR+EIRFunPLR<sub>3</sub>PLR<sup>2</sup>
  <p>
  where the performance curve coefficients from <i>EIRFunPLR<sub>1</sub> to EIRFunPLR<sub>3</sub> </i>
  are stored in the data record <code>per</code>.
  </p>
  </li>
  </ol>
  <p>
  The data record <code>per</code> is available at
  <a href=\"Buildings.Fluid.Chillers.Data.ElectricEIR\">
  Buildings.Fluid.Chillers.Data.ElectricEIR</a>.
  Additional performance curves can be developed using
  two available techniques Hydeman and Gillespie, (2002). The first technique is called the
  Least-squares Linear Regression method and is used when sufficient performance data exist
  to employ standard least-square linear regression techniques. The second technique is called
  Reference Curve Method and is used when insufficient performance data exist to apply linear
  regression techniques.
  </p>
  <p>
  The model has three tests on the part load ratio and the cycling ratio:
  </p>
  <ol>
  <li>
  The test<pre>
    PLR1 =min(QEva_flow_set/QEva_flow_ava, PLRMax);
  </pre>
  ensures that the heatpump capacity does not exceed the heatpump capacity specified
  by the parameter <code>PLRMax</code>.
  </li>
  <li>
  The test <pre>
    CR = min(PLR1/per.PRLMin, 1.0);
  </pre>
  computes a cycling ratio. This ratio expresses the fraction of time
  that a heatpump would run if it were to cycle because its load is smaller than the
  minimal load at which it can operate.
  Note that this model continuously operates even if the part load ratio is below the
  minimum part load ratio.
  Its leaving evaporator and condenser temperature can therefore be considered as an
  average temperature between the modes where the compressor is off and on.
  </li>
  <li>
  The test <pre>
    PLR2 = max(per.PLRMinUnl, PLR1);
  </pre>
  computes the part load ratio of the compressor.
  The assumption is that for a part load ratio below <code>per.PLRMinUnl</code>,
  the heatpump uses hot gas bypass to reduce the capacity, while the compressor
  power draw does not change.
  </li>
  </ol>
  <p>
  The electric power only contains the power for the compressor, but not any power
  for pumps or fans.
  </p>
  </html>",
  revisions="<html>
  <ul>
  <li>
June 24, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end DOE2Method;
