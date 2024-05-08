within Buildings.Fluid.HeatPumps.ModularReversible;
model TableData2D
  "Reversible heat pump based on 2D manufacturer data"
  extends Buildings.Fluid.HeatPumps.ModularReversible.Modular(
    final use_rev=true,
    QCoo_flow_nominal=refCyc.refCycHeaPumCoo.QCooNoSca_flow_nominal*scaFacHea,
    dpEva_nominal=datTabHea.dpEva_nominal*scaFacHea^2,
    dpCon_nominal=datTabHea.dpCon_nominal*scaFacHea^2,
    redeclare replaceable
      Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
      safCtrPar constrainedby
      Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Generic(
      final tabUppHea=datTabHea.tabUppBou,
      final tabLowCoo=datTabCoo.tabLowBou,
      final use_TConOutHea=datTabHea.use_TConOutForOpeEnv,
      final use_TEvaOutHea=datTabHea.use_TEvaOutForOpeEnv,
      final use_TConOutCoo=datTabCoo.use_TConOutForOpeEnv,
      final use_TEvaOutCoo=datTabCoo.use_TEvaOutForOpeEnv),
    dTEva_nominal=(QHea_flow_nominal - PEle_nominal)/cpEva/mEva_flow_nominal,
    mEva_flow_nominal=datTabHea.mEva_flow_nominal*scaFacHea,
    mCon_flow_nominal=datTabHea.mCon_flow_nominal*scaFacHea,
    dTCon_nominal=QHea_flow_nominal/cpCon/mCon_flow_nominal,
    GEvaIns=0,
    GEvaOut=0,
    CEva=0,
    use_evaCap=false,
    GConIns=0,
    GConOut=0,
    CCon=0,
    use_conCap=false,
    redeclare model RefrigerantCycleHeatPumpCooling =
        Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D (
        redeclare
          Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal,
        final mCon_flow_nominal=mCon_flow_nominal,
        final mEva_flow_nominal=mEva_flow_nominal,
        final smoothness=smoothness,
        final extrapolation=extrapolation,
        final datTab=datTabCoo),
    redeclare model RefrigerantCycleHeatPumpHeating =
        Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D (
        redeclare
          Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal,
        final mCon_flow_nominal=mCon_flow_nominal,
        final mEva_flow_nominal=mEva_flow_nominal,
        final smoothness=smoothness,
        final extrapolation=extrapolation,
        final datTab=datTabHea),
    redeclare model RefrigerantCycleInertia =
        Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia);
  final parameter Real scaFacHea=refCyc.refCycHeaPumHea.scaFac
    "Scaling factor of heat pump";
  final parameter Real scaFacCoo=refCyc.refCycHeaPumCoo.scaFac
    "Scaling factor for cooling mode";

  replaceable parameter
    Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump datTabHea
    constrainedby
    Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump
    "Data table of heat pump"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{82,-18},{98,-2}})));
  replaceable parameter Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic datTabCoo(
      use_TEvaOutForTab=true, use_TConOutForTab=true)
    constrainedby
    Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic
    "Data table of chiller"    annotation (choicesAllMatching=true,
    Placement(transformation(extent={{114,-18},{130,-2}})));

  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation" annotation (Dialog(tab="Advanced"));
  parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints
    "Extrapolation of data outside the definition range"
    annotation (Dialog(tab="Advanced"));
initial algorithm
  assert(use_rev and (abs(scaFacHea - scaFacCoo) / scaFacHea < limWarSca),
    "In " + getInstanceName() + ": Scaling factors for heating and cooling
    operation differ by " + String((scaFacHea - scaFacCoo) / scaFacHea * 100) +
    " %. The simulated nominal heating and cooling
    capacities may not be realistic for a single device",
    AssertionLevel.warning);

  annotation (Documentation(info="<html>
<p>
  Heat pump based on
  two-dimensional data from manufacturer data, (e.g. based on EN 14511),
  using the
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Modular\">
  Buildings.Fluid.HeatPumps.ModularReversible.Modular</a> approach.
</p>
<p>
  For more information on the approach, see
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.UsersGuide\">
  Buildings.Fluid.HeatPumps.ModularReversible.UsersGuide</a>.
</p>
<p>
  Internal inertias and heat losses are typically neglected,
  as these are implicitly obtained in measured
  data from manufacturers.
  Also, icing is disabled as the performance degradation
  is already contained in the data.
</p>

<h4>Sizing</h4>

<p>
  At the nominal conditions, the refrigerant cycle model will
  calculate the unscaled nominal heat flow rate, which is
  named <code>QHeaNoSca_flow_nominal</code> for heat pumps and
  <code>QCooNoSca_flow_nominal</code> for chillers.
  This value is probably
  different from <code>QHea_flow_nominal</code> and
  <code>QCoo_flow_nominal</code> which is for sizing.
  For example, suppose you need a 7.6 kW heat pump,
  but the datasheets only provides 5 kW and 10 kW options.
  In such cases, the performance data and relevant parameters
  are scaled using a scaling factor <code>scaFac</code>.
  Resulting, the refrigerant machine can supply more or less heat with
  the COP staying constant. However, one has to make sure
  that the movers in use also scale with this factor.
  Note that most parameters are scaled linearly. Only the
  pressure differences are scaled quadratically due to
  the linear scaling of the mass flow rates and the
  basic assumption:
  <p align=\"center\" style=\"font-style:italic;\">
  k = m&#775; &frasl; &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
  Both <code>QHeaNoSca_flow_nominal</code> or <code>QCooNoSca_flow_nominal</code>
  and <code>scaFac</code>
  are calculated in the refrigerant cycle models.
</p>


<p>
Please read the documentation of the model for heating at
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D</a>.
</p>
<p>
For cooling, the assumptions are similar, and described at
  <a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D\">
  Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D</a>
</p>
<h4>References</h4>
<p>
EN 14511-2018: Air conditioners, liquid chilling packages and heat pumps for space
heating and cooling and process chillers, with electrically driven compressors
<a href=\"https://www.beuth.de/de/norm/din-en-14511-1/298537524\">
https://www.beuth.de/de/norm/din-en-14511-1/298537524</a>
</p>

</html>"));
end TableData2D;
