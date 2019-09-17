within Buildings.Fluid.HeatPumps.BaseClasses;
block ReverseWaterToWater
  "Equation fit method to compute the performance of the reverse heat pump"
  extends Modelica.Blocks.Icons.Block;

  parameter Data.ReverseWaterToWater.Generic per
   "Performance data"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{60,72},
          {80,92}})));
  parameter Real scaling_factor
   "Scaling factor for heat pump capacity";

  parameter Boolean reverseCycle=true
  "= true, if the heat pump can be reversed to also operate in cooling mode"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));
  parameter Real a[:] = {1}
   "Coefficients for efficiency curve"
    annotation (Dialog(group="Efficiency"));

  final parameter Boolean evaluate_etaPL=
   not ((size(a, 1) == 1 and abs(a[1] - 1)  < Modelica.Constants.eps))
   "Flag, true if etaPL should be computed as it depends on PLR"
    annotation(Evaluate=true);

  Modelica.Blocks.Interfaces.IntegerInput uMod
   "Control input signal, cooling mode= -1, off=0, heating mode=+1"
    annotation (Placement(transformation(extent={{-124,-12},{-100,12}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TLoaEnt(
    final unit="K",
    displayUnit="degC")
   "Load entering water temperature"
    annotation (Placement(transformation(extent={{-124,68},{-100,92}}),
        iconTransformation(extent={{-120,62},{-100,82}})));
  Modelica.Blocks.Interfaces.RealInput TSouEnt(
    final unit="K",
    displayUnit="degC")
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

  Modelica.Blocks.Interfaces.RealInput QCoo_flow_set(final unit="W") if
       reverseCycle
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

  Real etaPL(final unit = "1")=
    if evaluate_etaPL
      then Buildings.Utilities.Math.Functions.polynomial(a=a, x=PLR)
    else 1
     "Efficiency due to part load";

  Modelica.SIunits.Efficiency QRel_flow
   "Thermal load ratio";
  Modelica.SIunits.Efficiency PRel
   "Power ratio";
  Modelica.SIunits.HeatFlowRate Q_flow_ava
   "Heat (or cooling) capacity available";
  Real PLR(min=0, nominal=1, unit="1")
   "Part load ratio";

protected
  parameter Modelica.SIunits.HeatFlowRate Q_flow_small = per.hea.Q_flow*1E-9*scaling_factor
   "Small value for heat flow rate or power, used to avoid division by zero";
  Real A1[5] "Thermal load ratio coefficients";
  Real x1[5] "Normalized inlet variables";
  Real A2[5] "Compressor power ratio coefficients";
  Real x2[5] "Normalized inlet variables";

  Modelica.Blocks.Interfaces.RealInput QCoo_flow_set_internal(final unit= "W")
   "Needed to connect the conditional connector";

initial equation
  assert(per.hea.Q_flow> 0,
   "Parameter QheaLoa_flow_nominal must be larger than zero.");
  assert(per.coo.Q_flow< 0,
   "Parameter QCooLoa_flow_nominal must be lesser than zero.");
  assert(Q_flow_small > 0,
   "Parameter Q_flow_small must be larger than zero.");

equation
  connect(QCoo_flow_set_internal, QCoo_flow_set);
  if not reverseCycle then
    QCoo_flow_set_internal = 0;
  end if;

  if (uMod==1) then
    A1=per.hea.coeQ;
    x1={1,
        TLoaEnt/per.hea.TRefLoa,
        TSouEnt/per.hea.TRefSou,
        m1_flow/(per.mLoa_flow*scaling_factor),
        m2_flow/(per.mSou_flow*scaling_factor)};
    A2= per.hea.coeP;
    x2={1,
        TLoaEnt/per.hea.TRefLoa,
        TSouEnt/per.hea.TRefSou,
        m1_flow/(per.mLoa_flow*scaling_factor),
        m2_flow/(per.mSou_flow*scaling_factor)};
    QRel_flow = sum( A1.*x1);
    PRel =  sum( A2.*x2);
    PLR =Buildings.Utilities.Math.Functions.smoothMin(
      x1=QHea_flow_set/(Q_flow_ava + Q_flow_small),
      x2=1,
      deltaX=1/100);
    Q_flow_ava = QRel_flow *(per.hea.Q_flow*scaling_factor);
    QLoa_flow   =Buildings.Utilities.Math.Functions.smoothMin(
      x1=QHea_flow_set,
      x2=Q_flow_ava,
      deltaX=Q_flow_small/10);
      P = etaPL*PRel*PLR*per.hea.P*scaling_factor; // fixme: Is this multiplication by etaPL correct?
    QSou_flow = -(QLoa_flow -P);
  elseif (uMod==-1) then
    A1= per.coo.coeQ;
    x1={1,
        TLoaEnt/per.coo.TRefLoa,
        TSouEnt/per.coo.TRefSou,
        m1_flow/(per.mLoa_flow*scaling_factor),
        m2_flow/(per.mSou_flow*scaling_factor)};
    A2= per.coo.coeP;
    x2={1,
        TLoaEnt/per.coo.TRefLoa,
        TSouEnt/per.coo.TRefSou,
        m1_flow/(per.mLoa_flow*scaling_factor),
        m2_flow/(per.mSou_flow*scaling_factor)};
    QRel_flow  = sum(A1.*x1);
    PRel  = sum(A2.*x2);
    Q_flow_ava = QRel_flow*per.coo.Q_flow*scaling_factor;
    QLoa_flow =Buildings.Utilities.Math.Functions.smoothMax(
      x1=QCoo_flow_set_internal,
      x2=Q_flow_ava,
      deltaX=Q_flow_small/10);
    PLR =Buildings.Utilities.Math.Functions.smoothMin(
      x1=QCoo_flow_set_internal/(Q_flow_ava - Q_flow_small),
      x2=1,
      deltaX=1/100);

    P = PRel*etaPL*PLR*per.coo.P*scaling_factor; // fixme: Is this multiplication by etaPL correct?
    QSou_flow = -QLoa_flow + P;
  else
    A1={0,0,0,0,0};
    x1={0,0,0,0,0};
    A2={0,0,0,0,0};
    x2={0,0,0,0,0};
    QRel_flow=0;
    PRel = 0;
    P = 0;
    Q_flow_ava = 0;
    QLoa_flow   = 0;
    QSou_flow   = 0;
    PLR=0;
  end if;
annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
           Diagram(coordinateSystem(preserveAspectRatio=false)),
  defaultComponentName="equFit",
  Documentation(info="<html>
<p>
Block that implements the equation fit method for the reverse heat pump model
<a href=\"Buildings.Fluid.HeatPumps.ReverseWaterToWater\">
Buildings.Fluid.HeatPumps.ReverseWaterToWater</a>.
</p>
<p>
The following five functions are implemented to predict the thermal capacity and power consumption for the two operational modes
of the reverse heat pump as
</p>
<ul>
<li>
If <code>uMod = 1</code>, the heat pump is in heating mode, and the governing equations are the linear functions
<p align=\"center\" style=\"font-style:italic;\">
QRel_flow =
    hea.coeQ<sub>1</sub>
 + hea.coeQ<sub>2</sub> T<sub>loa,ent</sub>/T<sub>RefHeaLoa</sub>
 + hea.coeQ<sub>3</sub> T<sub>sou,ent</sub>/T<sub>RefHeaSou</sub>
 + hea.coeQ<sub>4</sub> m&#775;<sub>loa,ent</sub>/m&#775;<sub>loa,nominal</sub>
 + hea.coeQ<sub>5</sub> m&#775;<sub>sou,ent</sub>/m&#775;<sub>sou,nominal</sub>
</p>
<p>
where <i>QRel_flow</i> is the relative heat provided and
<p align=\"center\" style=\"font-style:italic;\">
  PRel=
    hea.coeP<sub>1</sub>
  + hea.coeP<sub>2</sub> T<sub>loa,ent</sub>/T<sub>RefHeaLoa</sub>
  + hea.coeP<sub>3</sub> T<sub>sou,ent</sub>/T<sub>RefHeaSou</sub>
  + hea.coeP<sub>4</sub>  m&#775;<sub>loa,ent</sub>/m&#775;<sub>loa,nominal</sub>
  + hea.coeP<sub>5</sub> m&#775;<sub>sou,ent</sub>/m&#775;<sub>sou,nominal</sub>
</p>
<p>
where <code>PRel</code> is the relative power consumption, prior to applying an optional correction for the part load efficiency.
</p>
</li>
<li>
If <code>uMod = -1</code>, the heat pump is in cooling mode, and the governing equations are as above, but
with <i>coo.coeQ</i> and <i>coo.coeP</i> used instead of <i>hea.coeQ</i> and <i>hea.coeP</i>.
</li>
<li>
If <code>uMod = 0</code>, the model sets <i>QRel_flow = 0</i> and <i>PRel = 0</i>
</li>.
</ul>
<p>
The change in the performance due to heat pump part-load can be taken into account by evaluating the part-load efficiency <code>etaPL</code>
as a polynomial function of the form
<p align=\"center\" style=\"font-style:italic;\">
  &eta;<sub>PL</sub> = a<sub>1</sub> + a<sub>2</sub> PLR + a<sub>3</sub> PLR<sup>2</sup> + ...
  </li>
  </ul>
  <p>
where the coefficients <i>a<sub>i</sub></i> are declared by the parameter <code>a</code> and PLR is the part-load ratio.
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
