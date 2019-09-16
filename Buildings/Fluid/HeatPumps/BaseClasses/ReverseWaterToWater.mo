within Buildings.Fluid.HeatPumps.BaseClasses;
block ReverseWaterToWater
  "EquationFit method to predict the reverse heatpump performance"
  extends Modelica.Blocks.Icons.Block;

    parameter Data.ReverseWaterToWater.Generic per
     "Performance data"
      annotation (choicesAllMatching=true, Placement(transformation(extent={{78,80},
            {98,100}})));
    parameter Real scaling_factor
     "Scaling factor for heat pump capacity";
    parameter Modelica.SIunits.HeatFlowRate Q_flow_small = per.QHea_flow_nominal*1E-9*scaling_factor
     "Small value for heat flow rate or power, used to avoid division by zero";
    parameter Boolean reverseCycle=true
     "= true, if reversing the heatpump to cooling mode is required"
      annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));
    parameter Real a[:] = {1}
     "Coefficients for efficiency curve"
      annotation (Dialog(group="Efficiency"));
    final parameter Boolean evaluate_etaPL=
     not ((size(a, 1) == 1 and abs(a[1] - 1)  < Modelica.Constants.eps))
     "Flag, true if etaPL should be computed as it depends on PLR"
      annotation(Evaluate=true);

    Real etaPL(final unit = "1")=
    if evaluate_etaPL
      then Buildings.Utilities.Math.Functions.polynomial(a=a, x=PLR)
    else 1
     "Efficiency due to part load";
    Modelica.Blocks.Interfaces.IntegerInput uMod
     "Heatpump control input signal, heating mode= 1, off=0, cooling mode=-1"
      annotation (Placement(transformation(extent={{-124,-12},{-100,12}}),
          iconTransformation(extent={{-120,-10},{-100,10}})));
    Modelica.Blocks.Interfaces.RealInput TLoaEnt(final unit="K", displayUnit="degC")
     "Load entering water temperature"
      annotation (Placement(transformation(extent={{-124,68},{-100,92}}),
          iconTransformation(extent={{-120,62},{-100,82}})));
    Modelica.Blocks.Interfaces.RealInput TSouEnt(final unit="K", displayUnit="degC")
     "Source entering water temperature"
      annotation (Placement(transformation(extent={{-124,-92},{-100,-68}}),
          iconTransformation(extent={{-120,-78},{-100,-58}})));
    Modelica.Blocks.Interfaces.RealInput m1_flow(final unit="kg/s")
     "Volume 1 mass flow rate "
      annotation (Placement(transformation(extent={{-124,16},{-100,40}}),
          iconTransformation(extent={{-120,12},{-100,32}})));
    Modelica.Blocks.Interfaces.RealInput m2_flow(final unit="kg/s")
     "Volume2 mass flow rate"
      annotation (Placement(transformation(extent={{-124,-42},{-100,-18}}),
          iconTransformation(extent={{-120,-34},{-100,-14}})));
    Modelica.Blocks.Interfaces.RealInput QHea_flow_set(final unit="W")
     "Setpoint heating flow rate for the load heat exchanger"
      annotation (Placement(transformation(
          extent={{-124,42},{-100,66}}), iconTransformation(extent={{-120,38},{-100,58}})));
    Modelica.Blocks.Interfaces.RealInput QCoo_flow_set(final unit="W")
     "Setpoint cooling flow rate for the load heat exchanger"
      annotation (Placement(transformation(
          extent={{-124,-66},{-100,-42}}), iconTransformation(extent={{-120,-56},{-100,
            -36}})));
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
    Modelica.Blocks.Interfaces.BooleanOutput assMsg
     "generate alarm message if reverseCycle=false and uMod=-1 "
      annotation (Placement(transformation(extent={{100,50},{120,70}}),
        iconTransformation(extent={{100,64},{120,84}})));
    Modelica.SIunits.Efficiency LRH
     "Load ratio in heating mode";
    Modelica.SIunits.Efficiency LRC
     "Load ratio in cooling mode";
    Modelica.SIunits.Efficiency PRH
     "Power ratio in heating mode";
    Modelica.SIunits.Efficiency PRC
     "Power ratio in cooling mode";
    Modelica.SIunits.HeatFlowRate QHea_flow_ava
     "Heating capacity available";
    Modelica.SIunits.HeatFlowRate QCoo_flow_ava
     "Cooling capacity available";
    Real PLR(min=0, nominal=1, unit="1")
     "Part load ratio";
    Modelica.Blocks.Math.IntegerToBoolean integerToBoolean(threshold=1)
      annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
    Modelica.Blocks.Logical.Not not1
      annotation (Placement(transformation(extent={{40,50},{60,70}})));
    Controls.OBC.CDL.Logical.And and1
      annotation (Placement(transformation(extent={{0,50},{20,70}})));
    Controls.OBC.CDL.Logical.Sources.Constant revCyc(k=reverseCycle)
     "=true if reverse heatpump is required"
      annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

protected
    Real A1[5] "Thermal load ratio coefficients";
    Real x1[5] "Normalized inlet variables";
    Real A2[5] "Compressor power ratio coefficients";
    Real x2[5] "Normalized inlet variables";

initial equation
    assert(per.QHea_flow_nominal> 0,
     "Parameter QheaLoa_flow_nominal must be larger than zero.");
    assert(per.QCoo_flow_nominal< 0,
     "Parameter QCooLoa_flow_nominal must be lesser than zero.");
    assert(Q_flow_small > 0,
     "Parameter Q_flow_small must be larger than zero.");

equation

    if (uMod==1) then

      A1=per.LRCH;
      x1={1,TLoaEnt/per.TRefHeaLoa,TSouEnt/per.TRefHeaSou,
      m1_flow/(per.mLoa_flow_nominal*scaling_factor),m2_flow/(per.mSou_flow_nominal*scaling_factor)};

      A2= per.PRCH;
      x2={1,TLoaEnt/per.TRefHeaLoa,TSouEnt/per.TRefHeaSou,
      m1_flow/(per.mLoa_flow_nominal*scaling_factor),m2_flow/(per.mSou_flow_nominal*scaling_factor)};

      LRH = sum( A1.*x1);
      LRC = 0;
      PRH =  sum( A2.*x2);
      PRC = 0;

      PLR =Buildings.Utilities.Math.Functions.smoothMin(
      x1=QHea_flow_set/(QHea_flow_ava + Q_flow_small),
      x2=1,
      deltaX=1/100);

      QHea_flow_ava = LRH *(per.QHea_flow_nominal*scaling_factor);

      QCoo_flow_ava = 0;

      QLoa_flow   =Buildings.Utilities.Math.Functions.smoothMin(
      x1=QHea_flow_set,
      x2=QHea_flow_ava,
      deltaX=Q_flow_small/10);

      P = etaPL*PRH*PLR*(per.P_nominal_hea*scaling_factor);
      QSou_flow = -(QLoa_flow -P);

    elseif (uMod==-1) and reverseCycle then

      A1= per.LRCC;
      x1={1,TLoaEnt/per.TRefCooLoa,TSouEnt/per.TRefCooSou,
      m1_flow/(per.mLoa_flow_nominal*scaling_factor),m2_flow/(per.mSou_flow_nominal*scaling_factor)};

      A2= per.PRCC;
      x2={1,TLoaEnt/per.TRefCooLoa,TSouEnt/per.TRefCooSou,
      m1_flow/(per.mLoa_flow_nominal*scaling_factor),m2_flow/(per.mSou_flow_nominal*scaling_factor)};

      LRH  = 0;
      LRC  = sum(A1.*x1);
      PRH  =  0;
      PRC  = sum(A2.*x2);
      QHea_flow_ava = 0;
      QCoo_flow_ava = LRC* (per.QCoo_flow_nominal*scaling_factor);

      QLoa_flow =Buildings.Utilities.Math.Functions.smoothMax(
      x1=QCoo_flow_set,
      x2=QCoo_flow_ava,
      deltaX=Q_flow_small/10);
      PLR =Buildings.Utilities.Math.Functions.smoothMin(
      x1=QCoo_flow_set/(QCoo_flow_ava - Q_flow_small),
      x2=1,
      deltaX=1/100);

      P = PRC*etaPL*PLR*(per.P_nominal_coo*scaling_factor);
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
      QHea_flow_ava = 0;
      QCoo_flow_ava = 0;
      QLoa_flow   = 0;
      QSou_flow   = 0;
      PLR=0;

    end if;
  connect(uMod, integerToBoolean.u)
    annotation (Line(points={{-112,0},{-60,0},{-60,80},{-42,80}},color={255,127,0}));
  connect(integerToBoolean.y, and1.u1)
    annotation (Line(points={{-19,80},{-12,
          80},{-12,60},{-2,60}}, color={255,0,255}));
  connect(revCyc.y, and1.u2)
    annotation (Line(points={{-18,40},{-12,40},{-12,52},
          {-2,52}}, color={255,0,255}));
  connect(and1.y, not1.u)
    annotation (Line(points={{22,60},{38,60}}, color={255,0,255}));
  connect(not1.y, assMsg)
    annotation (Line(points={{61,60},{110,60}}, color={255,0,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
              Diagram(coordinateSystem(preserveAspectRatio=false)),
  defaultComponentName="equFit",
  Documentation(info="<html>
  <p>
  The block describes the equation fit method implemented at the reverse heatpump model
  <a href=\"Buildings.Fluid.HeatPumps.ReverseWaterToWater\">
   Buildings.Fluid.HeatPumps.ReverseWaterToWater</a>.
  </p>
  <p>
  The following five functions are implemented to predict the thermal capacity and power consumption for the two operational modes
  of the reverse heat pump as
  </p>
  <ul>
  <li>
  The heating mode is energized when the integer input signal <code>uMod</code>=1 and the governing equations are
  </li>
  <p align=\"center\" style=\"font-style:italic;\">
  HLR = HLRC<sub>1</sub>+ HLRC<sub>2</sub> T<sub>Loa,Ent</sub>/T<sub>RefHeaLoa</sub>+
  HLRC<sub>3</sub> T<sub>Sou,Ent</sub>/T<sub>RefHeaSou</sub>+ HLRC<sub>4</sub> m&#775;<sub>Loa,Ent</sub>/m&#775;<sub>Loa,nominal</sub>+
  HLRC<sub>5</sub> m&#775;<sub>Sou,Ent</sub>/m&#775;<sub>Sou,nominal</sub>

  <p align=\"center\" style=\"font-style:italic;\">
  PRH= PHC<sub>1</sub>+ PHC<sub>2</sub> T<sub>Loa,Ent</sub>/T<sub>RefHeaLoa</sub>+
  PHC<sub>3</sub> T<sub>Sou,Ent</sub>/T<sub>RefHeaSou</sub>+ PHC<sub>4</sub>  m&#775;<sub>Loa,Ent</sub>/m&#775;<sub>Loa,nominal</sub>+
  PHC<sub>5</sub> m&#775;<sub>Sou,Ent</sub>/m&#775;<sub>Sou,nominal</sub>
  </ul>
  <p>
  where the heating load ratio <code>HLR</code>=Q&#775;<sub>Loa_flow</sub>/Q&#775;<sub>Hea,nominal</sub> ,
  the compressor power ratio in heating mode <code>PRH</code>= P/P<sub>nominal_hea</sub> and the performance coefficients
  <i>HLRC<sub>1</sub> to HLRC<sub>5</sub> </i>, <i>PHC<sub>1</sub> to PHC<sub>5</sub> </i>
  are stored in the data record <code>per</code> at <a href=\"Buildings.Fluid.HeatPumps.Data.ReverseWaterToWater\">
  Buildings.Fluid.HeatPumps.Data.ReverseWaterToWater</a>.
  </p>
  <ul>
  <li>
  The cooling mode is energized when the integer input signal <code>uMod</code>=-1 and the governing equations  are
  </li>
  <p align=\"center\" style=\"font-style:italic;\">
  CLR = CLRC<sub>1</sub>+ CLRC<sub>2</sub> T<sub>Loa,Ent</sub>/T<sub>RefCooLoa</sub>+
  CLRC<sub>3</sub> T<sub>Sou,Ent</sub>/T<sub>RefCooSou</sub>+ CLRC<sub>4</sub> m&#775;<sub>LoaEnt</sub>/m&#775;<sub>Loa,nominal</sub>+
  CLRC<sub>5</sub> m&#775;<sub>Sou,Ent</sub>/m&#775;<sub>Sou,nominal</sub>
  <p align=\"center\" style=\"font-style:italic;\">

  PRC = PCC<sub>1</sub>+ PCC<sub>2</sub>.T<sub>Loa,Ent</sub>/T<sub>TRefCooLoa</sub>+
   PCC<sub>3</sub> T<sub>Sou,Ent</sub>/T<sub>RefCooSou</sub>+ PCC<sub>4</sub> m&#775;<sub>Loa,Ent</sub>/m&#775;<sub>Loa,nominal</sub>
   + PCC<sub>5</sub> m&#775;<sub>Sou,Ent</sub>/m&#775;<sub>Sou,nominal</sub>
   </ul>
   <p>
  where the cooling load ratio <code>CLR</code>= Q&#775;<sub>Loa_flow</sub>/Q&#775;<sub>Coo,nominal</sub>,
  the compressor power ratio in cooling mode <code>PRC</code> =P/P<sub>nominal_coo</sub> and the performance coefficients <i>CLRC<sub>1</sub> to CLRC<sub>5</sub> </i> , <i>PCC<sub>1</sub> to PCC<sub>5</sub> </i>
  are stored in the data record <code>per</code> at <a href=\"Buildings.Fluid.HeatPumps.Data.ReverseWaterToWater\">
  Buildings.Fluid.HeatPumps.Data.ReverseWaterToWater</a>.
   </p>
   <ul>
   <li>
  The change in the performance due to heatpump part-load is taken into account by evaluating the part-load efficiency <code>etaPL</code>
  as a polynomial function of the form
  </li>

  <p align=\"center\" style=\"font-style:italic;\">
    &eta;<sub>PL</sub> = a<sub>1</sub> + a<sub>2</sub> PLR + a<sub>3</sub> PLR<sup>2</sup> + ...
    </ul>
    <p>
  where the coefficients <i>a<sub>i</sub></i> are declared by the parameter <code>a</code>, and PLR is the part-load ratio.
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
end ReverseWaterToWater;
