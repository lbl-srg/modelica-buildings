within Buildings.Fluid.HeatPumps.BaseClasses;
block EquationFitMethod
  "EquationFit method implemented to predict heatpump thermal performance"
  extends Modelica.Blocks.Icons.Block;

   parameter Data.EquationFitWaterToWater.Generic per
   "Performance data"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{78,80},
            {98,100}})));
    parameter Real scaling_factor
    "Scaling factor for heat pump capacity";
    parameter Modelica.SIunits.HeatFlowRate Q_flow_small = per.QCon_flow_nominal*1E-9*scaling_factor
    "Small value for heat flow rate or power, used to avoid division by zero";
    parameter Real a[:] = {1}
    "Coefficients for efficiency curve (need p(a=a, PLR=1)=1)"
    annotation (Dialog(group="Efficiency"));
    final parameter Boolean evaluate_etaPL=
    (size(a, 1) == 1 and abs(a[1] - 1)  < Modelica.Constants.eps)
    "Flag, true if etaPL should be computed as it depends on part-load ratio PLR"
    annotation(Evaluate=true);

    Real etaPL(final unit = "1")=
    if evaluate_etaPL
      then 1
    else Buildings.Utilities.Math.Functions.polynomial(a=a, x=PLR)
    "Efficiency due to part load (etaPL(PLR=1)=1)";
    Modelica.Blocks.Interfaces.RealInput TEvaSet(final unit="K", displayUnit="degC")
    "Set point for leaving chilled water temperature"
       annotation (Placement(transformation(extent={{-124,-112},{-100,-88}}),
          iconTransformation(extent={{-118,-108},{-100,-90}})));
    Modelica.Blocks.Interfaces.RealInput TConSet(final unit="K", displayUnit="degC")
    "Set point for leaving heating water temperature"
       annotation (Placement(transformation(extent={{-122,88},{-100,110}}),
          iconTransformation(extent={{-120,88},{-100,108}})));
    Modelica.Blocks.Interfaces.IntegerInput uMod
    "HeatPump control input signal, Heating mode= 1, Off=0, Cooling mode=-1"
       annotation (Placement(transformation(extent={{-124,-12},{-100,12}}),
          iconTransformation(extent={{-122,-12},{-104,6}})));
    Modelica.Blocks.Interfaces.RealInput TConEnt(final unit="K", displayUnit="degC")
    "Condenser entering water temperature"
       annotation (Placement(transformation(extent={{-124,58},{-100,82}}),
          iconTransformation(extent={{-120,58},{-100,78}})));
    Modelica.Blocks.Interfaces.RealInput TEvaEnt(final unit="K", displayUnit="degC")
    "Evaporator entering water temperature"
       annotation (Placement(transformation(extent={{-124,-82},{-100,-58}}),
          iconTransformation(extent={{-118,-84},{-100,-66}})));
    Modelica.Blocks.Interfaces.RealInput m1_flow(final unit="kg/s")
    "Volume 1 massflow rate "
       annotation (Placement(transformation(extent={{-124,8},{-100,32}}),
          iconTransformation(extent={{-120,10},{-100,30}})));
    Modelica.Blocks.Interfaces.RealInput m2_flow(final unit="kg/s")
    "Volume2 mass flow rate"
       annotation (Placement(transformation(extent={{-124,-32},{-100,-8}}),
          iconTransformation(extent={{-118,-36},{-100,-18}})));
    Modelica.Blocks.Interfaces.RealInput QCon_flow_set(final unit="W")
    "Condenser setpoint heat flow rate"
      annotation (Placement(transformation(
          extent={{-124,34},{-100,58}}), iconTransformation(extent={{-120,34},{-100,
            54}})));
    Modelica.Blocks.Interfaces.RealInput QEva_flow_set(final unit="W")
    "Evaporator setpoint heat flow rate"
      annotation (Placement(transformation(
          extent={{-124,-58},{-100,-34}}), iconTransformation(extent={{-118,-60},
            {-100,-42}})));
    Modelica.Blocks.Interfaces.RealOutput QCon_flow(final unit="W")
    "Condenser heat flow rate "
       annotation (Placement(transformation(extent={{100,30},{120,50}}),
          iconTransformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.RealOutput QEva_flow(final unit="W")
    "Evaporator heat flow rate "
       annotation (Placement(transformation(extent={{100,-48},{120,-28}}),
          iconTransformation(extent={{100,-50},{120,-30}})));
    Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
    "Compressor power"
       annotation (Placement(transformation(extent={{100,-10},{120,10}}),
          iconTransformation(extent={{100,-10},{120,10}})));
    Modelica.SIunits.Efficiency LRH
    "Load ratio in heating mode";
    Modelica.SIunits.Efficiency LRC
    "Load ratio in cooling mode";
    Modelica.SIunits.Efficiency PRH
    "Power Ratio in heating mode";
    Modelica.SIunits.Efficiency PRC
    "Power Ratio in cooling mode";
    Modelica.SIunits.HeatFlowRate QCon_flow_ava
    "Heating capacity available at the condender";
    Modelica.SIunits.HeatFlowRate QEva_flow_ava
    "Cooling capacity available at the evaporator";
    Real PLR(min=0, nominal=1, unit="1")
    "Part load ratio";

protected
    Real A1[5] "Thermal load ratio coefficients";
    Real x1[5] "Normalized inlet variables";
    Real A2[5] "Compressor power ratio coefficients";
    Real x2[5] "Normalized inlet variables";

initial equation
   assert(per.QCon_flow_nominal> 0,
   "Parameter QCon_flow_nominal must be larger than zero.");
   assert(per.QEva_flow_nominal< 0,
   "Parameter QEva_flow_nominal must be lesser than zero.");
   assert(Q_flow_small > 0,
   "Parameter Q_flow_small must be larger than zero.");

equation
    if (uMod==1) then

      A1=per.LRCH;
      x1={1,TConEnt/per.TRefHeaCon,TEvaEnt/per.TRefHeaEva,
      m1_flow/(per.mCon_flow_nominal*scaling_factor),m2_flow/(per.mEva_flow_nominal*scaling_factor)};

      A2= per.PRCH;
      x2={1,TConEnt/per.TRefHeaCon,TEvaEnt/per.TRefHeaEva,
      m1_flow/(per.mCon_flow_nominal*scaling_factor),m2_flow/(per.mEva_flow_nominal*scaling_factor)};

      LRH  = sum( A1.*x1);
      LRC  = 0;
      PRH =  sum( A2.*x2);
      PRC = 0;
      QCon_flow_ava= LRH *(per.QCon_flow_nominal*scaling_factor);
      QEva_flow_ava = 0;

      PLR = Buildings.Utilities.Math.Functions.smoothMin(
                              x1 =  QCon_flow_set/(QCon_flow_ava + Q_flow_small),
                              x2 =  1,
                          deltaX =  1/100);

      QCon_flow =Buildings.Utilities.Math.Functions.smoothMin(
                              x1 =  QCon_flow_set,
                              x2 =  QCon_flow_ava,
                          deltaX =  Q_flow_small/10);

      P= PRH*etaPL* (per.P_nominal_hea*scaling_factor);
      QEva_flow= -(QCon_flow -P);

    elseif (uMod==-1) then

      A1= per.LRCC;
      x1={1,TConEnt/per.TRefCooCon,TEvaEnt/per.TRefCooEva,
      m1_flow/(per.mCon_flow_nominal*scaling_factor),m2_flow/(per.mEva_flow_nominal*scaling_factor)};

      A2= per.PRCC;
      x2={1,TConEnt/per.TRefCooCon,TEvaEnt/per.TRefCooEva,
      m1_flow/(per.mCon_flow_nominal*scaling_factor),m2_flow/(per.mEva_flow_nominal*scaling_factor)};

      LRH  = 0;
      LRC  = sum(A1.*x1);
      PRH  =  0;
      PRC  = sum(A2.*x2);
      QCon_flow_ava = 0;
      QEva_flow_ava = LRC* (per.QEva_flow_nominal*scaling_factor);

      QEva_flow =Buildings.Utilities.Math.Functions.smoothMax(
                              x1 =  QEva_flow_set,
                              x2 =  QEva_flow_ava,
                          deltaX =  Q_flow_small/10);

      PLR = Buildings.Utilities.Math.Functions.smoothMin(
                              x1 =  QEva_flow_set/(QEva_flow_ava - Q_flow_small),
                              x2 =  1,
                          deltaX =  1/100);

      P= PRC*etaPL*(per.P_nominal_coo*scaling_factor);
      QCon_flow =(-QEva_flow + P);

    else

      A1={0,0,0,0,0};
      x1={0,0,0,0,0};
      A2={0,0,0,0,0};
      x2={0,0,0,0,0};
      LRH= 0;
      LRC=0;
      PRH =0;
      PRC = 0;
      P = 0;
      QCon_flow_ava = 0;
      QEva_flow_ava = 0;
      QCon_flow = 0;
      QEva_flow = 0;
      PLR =0;

    end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
              Diagram(coordinateSystem(preserveAspectRatio=false)),
defaultComponentName="equFit",
Documentation(info="<html>
  <p>
  The Block includes the description of the equation fit method dedicated for
  <a href=\"Buildings.Fluid.HeatPumps.EquationFitWaterToWater\">
  Buildings.Fluid.HeatPumps.EquationFitWaterToWater</a>.
  </p>
  <p>
  The block uses four functions to predict capacity and power consumption for the heating and cooling modes.The governing equations for the heating mode are
  </p>

  <p align=\"center\" style=\"font-style:italic;\">
  LRH = LRHC<sub>1</sub>+ LRHC<sub>2</sub> T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>+
  LRHC<sub>3</sub> T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>+ LRHC<sub>4</sub> V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>+
  + LRHC<sub>5</sub> V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>

  <p align=\"center\" style=\"font-style:italic;\">
  PRH= PRHC<sub>1</sub>+ PRHC<sub>2</sub> T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>+
  PRHC<sub>3</sub>.T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>+ PRHC<sub>4</sub> V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>
  + PRHC<sub>5</sub> V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>
  <p>
  where the heating load ratio <code>LRH</code>=Q&#775;<sub>Con</sub>/Q&#775;<sub>Con,nominal</sub> , the compressor power ratio in heating mode <code>PRH</code>= P<sub>Con</sub>/P<sub>Con,nominal</sub> and the performance coefficients <i>LRHC<sub>1</sub> to LRHC<sub>5</sub> </i> , <i>PRHC<sub>1</sub> to PRHC<sub>5</sub> </i>
  are stored in the data record <code>per</code> at <a href=\"Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater\">
  Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater</a>. The heating mode is activated when the integer input signal <code>uMod</code>=1.
  </p>
  <p>
  While, the governing equations for the cooling mode are
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  LRC = LRCC<sub>1</sub>+ LRCC<sub>2</sub> T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>+
  LRCC<sub>3</sub> T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>+ LRCC<sub>4</sub> V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>+
  + LRCC<sub>5</sub> V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>

  <p align=\"center\" style=\"font-style:italic;\">
  PRC = PRCC<sub>1</sub>+ PRCC<sub>2</sub>.T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>+
   PRCC<sub>3</sub> T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>+ PRCC<sub>4</sub> V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>
   + PRCC<sub>5</sub> V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>
  <p>
  where the cooling load ratio <code>LRC</code>= Q&#775;<sub>Eva</sub>/Q&#775;<sub>Eva,nominal</sub>, the compressor power ratio in cooling mode <code>PRC</code> =P<sub>Eva</sub>/P<sub>Eva,nominal</sub> and the performance coefficients <i>LRCC<sub>1</sub> to LRCC<sub>5</sub> </i> , <i>PRCC<sub>1</sub> to PRCC<sub>5</sub> </i>
  are stored in the data record <code>per</code> at <a href=\"Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater\">
  Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater</a>.The cooling mode is activated when the integer input signal <code>uMod</code>=-1.
  </p>
  <p>
  For these four equations, the inlet conditions are divided by the reference conditions.
  This formulation allows the coefficients to fall into smaller range of values, moreover, the value of the coefficient
  represents the sensitivity of the output to that particular inlet variable.
  </p>
  </html>",
  revisions="<html>
  <ul>
  <li>
May 19, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end EquationFitMethod;
