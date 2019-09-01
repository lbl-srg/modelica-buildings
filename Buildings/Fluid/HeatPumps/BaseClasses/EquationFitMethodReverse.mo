within Buildings.Fluid.HeatPumps.BaseClasses;
block EquationFitMethodReverse
  "EquationFit method to predict heatpump performance"
  extends Modelica.Blocks.Icons.Block;

    parameter Data.EquationFitWaterToWater.GenericReverse per
    "Performance data"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{78,80},
            {98,100}})));
    parameter Real scaling_factor
    "Scaling factor for heat pump capacity";
    parameter Modelica.SIunits.HeatFlowRate Q_flow_small = per.QHeaLoa_flow_nominal*1E-9*scaling_factor
    "Small value for heat flow rate or power, used to avoid division by zero";
    parameter Boolean reverseCycle=true
   "= true, if reversing the heatpump to cooling mode is required"
    annotation(Dialog(tab="General", group="Reverse Cycle"));
    parameter Real a[:] = {1}
    "Coefficients for efficiency curve (need p(a=a, PLR=1)=1)"
    annotation (Dialog(group="Efficiency"));
    final parameter Boolean evaluate_etaPL=
    (size(a, 1) == 1 and abs(a[1] - 1)  < Modelica.Constants.eps)
    "Flag, true if etaPL should be computed as it depends on PLR"
    annotation(Evaluate=true);

    Real etaPL(final unit = "1")=
    if evaluate_etaPL
      then 1
    else Buildings.Utilities.Math.Functions.polynomial(a=a, x=PLR)
    "Efficiency due to part load (etaPL(PLR=1)=1)";
    Modelica.Blocks.Interfaces.RealInput TCooLoaSet(final unit="K", displayUnit=
       "degC") if reverseCycle "Set point for leaving chilled water temperature"
      annotation (
      Placement(transformation(extent={{-124,-112},{-100,-88}}),
        iconTransformation(extent={{-120,-106},{-100,-86}})));
    Modelica.Blocks.Interfaces.RealInput THeaLoaSet(final unit="K", displayUnit=
       "degC") "Set point for leaving heating water temperature" annotation (
      Placement(transformation(extent={{-124,86},{-100,110}}),
        iconTransformation(extent={{-120,88},{-100,108}})));
    Modelica.Blocks.Interfaces.IntegerInput uMod
    "HeatPump control input signal, Heating mode= 1, Off=0, Cooling mode=-1"
       annotation (Placement(transformation(extent={{-124,-12},{-100,12}}),
          iconTransformation(extent={{-120,-10},{-100,10}})));
    Modelica.Blocks.Interfaces.RealInput TLoaEnt(final unit="K", displayUnit="degC")
    "Load entering water temperature"
       annotation (Placement(transformation(extent={{-124,60},{-100,84}}),
          iconTransformation(extent={{-120,62},{-100,82}})));
    Modelica.Blocks.Interfaces.RealInput TSouEnt(final unit="K", displayUnit="degC")
    "Source entering water temperature"
       annotation (Placement(transformation(extent={{-124,-82},{-100,-58}}),
          iconTransformation(extent={{-120,-78},{-100,-58}})));
    Modelica.Blocks.Interfaces.RealInput m1_flow(final unit="kg/s")
    "Volume 1 massflow rate "
       annotation (Placement(transformation(extent={{-124,8},{-100,32}}),
          iconTransformation(extent={{-120,12},{-100,32}})));
    Modelica.Blocks.Interfaces.RealInput m2_flow(final unit="kg/s")
    "Volume2 mass flow rate"
       annotation (Placement(transformation(extent={{-124,-32},{-100,-8}}),
          iconTransformation(extent={{-120,-34},{-100,-14}})));
    Modelica.Blocks.Interfaces.RealInput QHeaLoa_flow_set(final unit="W")
    "Heating load setpoint heat flow rate" annotation (Placement(transformation(
          extent={{-124,34},{-100,58}}), iconTransformation(extent={{-120,38},{-100,
            58}})));
    Modelica.Blocks.Interfaces.RealInput QCooLoa_flow_set(final unit="W") if reverseCycle
    "Setpoint cooling flow rate for the load"
       annotation (Placement(
        transformation(extent={{-124,-56},{-100,-32}}), iconTransformation(
          extent={{-120,-56},{-100,-36}})));
    Modelica.Blocks.Interfaces.RealOutput QLoa_flow(final unit="W")
    "Load heat flow rate"
       annotation (Placement(transformation(extent={{100,30},{120,50}}),
          iconTransformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.RealOutput QSou_flow(final unit="W")
    "Source heat flow rate"
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
    Modelica.SIunits.HeatFlowRate QHeaLoa_flow_ava
    "Heating load available";
    Modelica.SIunits.HeatFlowRate QCooLoa_flow_ava
    "Cooling load available";
    Real PLR(min=0, nominal=1, unit="1")
    "Part load ratio";
    Modelica.Blocks.Math.IntegerToBoolean integerToBoolean(threshold=1)
    annotation (Placement(transformation(extent={{-34,56},{-14,76}})));
    Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{0,56},{20,76}})));
    Modelica.Blocks.Interfaces.BooleanOutput assMsg "generate alarm message"
    annotation (Placement(transformation(extent={{100,56},{120,76}}),
        iconTransformation(extent={{100,64},{120,84}})));
    Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{42,56},{62,76}})));
    Controls.OBC.CDL.Logical.Sources.Constant revCyc(k=reverseCycle)
    "=true if reverse heatpump is required"
    annotation (Placement(transformation(extent={{0,16},{20,36}})));
protected
    Real A1[5] "Thermal load ratio coefficients";
    Real x1[5] "Normalized inlet variables";
    Real A2[5] "Compressor power ratio coefficients";
    Real x2[5] "Normalized inlet variables";

initial equation
   assert(per.QHeaLoa_flow_nominal> 0,
   "Parameter QheaLoa_flow_nominal must be larger than zero.");
   assert(per.QCooLoa_flow_nominal< 0,
   "Parameter QCooLoa_flow_nominal must be lesser than zero.");
   assert(Q_flow_small > 0,
   "Parameter Q_flow_small must be larger than zero.");

equation
    if (uMod==1) then

      A1=per.LRCH;
      x1={1,TLoaEnt/per.TRefHeaCon,TSouEnt/per.TRefHeaEva,
      m1_flow/(per.mLoa_flow_nominal*scaling_factor),m2_flow/(per.mSou_flow_nominal*scaling_factor)};

      A2= per.PRCH;
      x2={1,TLoaEnt/per.TRefHeaCon,TSouEnt/per.TRefHeaEva,
      m1_flow/(per.mLoa_flow_nominal*scaling_factor),m2_flow/(per.mSou_flow_nominal*scaling_factor)};

      LRH = sum( A1.*x1);
      LRC = 0;
      PRH =  sum( A2.*x2);
      PRC = 0;

      PLR = Buildings.Utilities.Math.Functions.smoothMin(
                              x1 = QHeaLoa_flow_set/(QHeaLoa_flow_ava + Q_flow_small),
                              x2 = 1,
                          deltaX = 1/100);

      QHeaLoa_flow_ava = LRH *(per.QHeaLoa_flow_nominal*scaling_factor);

      QCooLoa_flow_ava = 0;

      QLoa_flow   = Buildings.Utilities.Math.Functions.smoothMin(
                             x1 = QHeaLoa_flow_set,
                             x2 = QHeaLoa_flow_ava,
                         deltaX = Q_flow_small/10);

       P = etaPL*PRH*(per.P_nominal_hea*scaling_factor);

       QSou_flow = -(QLoa_flow -P);

    elseif (uMod==-1) and reverseCycle then

      A1= per.LRCC;
      x1={1,TLoaEnt/per.TRefCooCon,TSouEnt/per.TRefCooEva,
      m1_flow/(per.mLoa_flow_nominal*scaling_factor),m2_flow/(per.mSou_flow_nominal*scaling_factor)};

      A2= per.PRCC;
      x2={1,TLoaEnt/per.TRefCooCon,TSouEnt/per.TRefCooEva,
      m1_flow/(per.mLoa_flow_nominal*scaling_factor),m2_flow/(per.mSou_flow_nominal*scaling_factor)};

      LRH  = 0;
      LRC  = sum(A1.*x1);
      PRH  =  0;
      PRC  = sum(A2.*x2);
      QHeaLoa_flow_ava = 0;
      QCooLoa_flow_ava = LRC* (per.QCooLoa_flow_nominal*scaling_factor);

      QLoa_flow = Buildings.Utilities.Math.Functions.smoothMax(
                            x1 = QCooLoa_flow_set,
                            x2 = QCooLoa_flow_ava,
                        deltaX = Q_flow_small/10);
      PLR = Buildings.Utilities.Math.Functions.smoothMin(
                            x1 = QCooLoa_flow_set/(QCooLoa_flow_ava - Q_flow_small),
                            x2 = 1,
                        deltaX = 1/100);

      P = PRC*etaPL*(per.P_nominal_coo*scaling_factor);

      QSou_flow = -QLoa_flow + P;

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
      QHeaLoa_flow_ava = 0;
      QCooLoa_flow_ava = 0;
      QLoa_flow   = 0;
      QSou_flow   = 0;
      PLR=0;

    end if;
  connect(uMod, integerToBoolean.u) annotation (Line(points={{-112,0},{-50,0},{-50,
          66},{-36,66}}, color={255,127,0}));
  connect(integerToBoolean.y, not1.u)
    annotation (Line(points={{-13,66},{-2,66}}, color={255,0,255}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{21,66},{40,66}}, color={255,0,255}));
  connect(assMsg, and2.y)
    annotation (Line(points={{110,66},{64,66}}, color={255,0,255}));
  connect(revCyc.y, and2.u2) annotation (Line(points={{22,26},{32,26},{32,58},{40,
          58}}, color={255,0,255}));
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
  HLR = HLRC<sub>1</sub>+ HLRC<sub>2</sub> T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>+
  HLRC<sub>3</sub> T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>+ HLRC<sub>4</sub> V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>+
  + HLRC<sub>5</sub> V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>

  <p align=\"center\" style=\"font-style:italic;\">
  PRH= PHC<sub>1</sub>+ PHC<sub>2</sub> T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>+
  PHC<sub>3</sub>.T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>+ PHC<sub>4</sub> V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>
  + PHC<sub>5</sub> V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>
  <p>
  where the heating load ratio <code>HLR</code>=Q&#775;<sub>Con</sub>/Q&#775;<sub>Con,nominal</sub> , the compressor power ratio in heating mode <code>PRH</code>= P<sub>Con</sub>/P<sub>Con,nominal</sub> and the performance coefficients <i>HLRC<sub>1</sub> to HLRC<sub>5</sub> </i> , <i>PHC<sub>1</sub> to PHC<sub>5</sub> </i>
  are stored in the data record <code>per</code> at <a href=\"Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater\">
  Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater</a>. The heating mode is activated when the integer input signal <code>uMod</code>=1.
  </p>
  <p>
  While, the governing equations for the cooling mode are
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  CLR = CLRC<sub>1</sub>+ CLRC<sub>2</sub> T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>+
  CLRC<sub>3</sub> T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>+ CLRC<sub>4</sub> V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>+
  + CLRC<sub>5</sub> V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>

  <p align=\"center\" style=\"font-style:italic;\">
  PRC = PCC<sub>1</sub>+ PCC<sub>2</sub>.T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>+
   PCC<sub>3</sub> T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>+ PCC<sub>4</sub> V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>
   + PCC<sub>5</sub> V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>
  <p>
  where the cooling load ratio <code>CLR</code>= Q&#775;<sub>Eva</sub>/Q&#775;<sub>Eva,nominal</sub>, the compressor power ratio in cooling mode <code>PRC</code> =P<sub>Eva</sub>/P<sub>Eva,nominal</sub> and the performance coefficients <i>CLRC<sub>1</sub> to CLRC<sub>5</sub> </i> , <i>PCC<sub>1</sub> to PCC<sub>5</sub> </i>
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
end EquationFitMethodReverse;
