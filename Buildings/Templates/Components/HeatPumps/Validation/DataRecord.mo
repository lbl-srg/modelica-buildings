within Buildings.Templates.Components.HeatPumps.Validation;
model DataRecord
  "Test model for parameter propagation with the heat pump data record"
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.HeatPumps.Data.EquationFitReversible.Trane_Axiom_EXW240 per;
  parameter Buildings.Templates.Components.Data.HeatPump datHeaPumRevAss(
    final typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    final is_rev=true,
    final typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit,
    mHeaWat_flow_nominal=datHeaPumRevAss.capHea_nominal/abs(Buildings.Templates.Data.Defaults.THeaWatSupMed
         - Buildings.Templates.Data.Defaults.THeaWatRetMed)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWat_nominal=Buildings.Templates.Data.Defaults.dpConWatChi,
    capHea_nominal=500E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    mChiWat_flow_nominal=datHeaPumRevAss.capCoo_nominal/abs(Buildings.Templates.Data.Defaults.TChiWatSup
         - Buildings.Templates.Data.Defaults.TChiWatRet)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCoo_nominal=500E3,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    perFit=per)
    "Parameters for reversible AWHP using performance data record assignment"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

  parameter Buildings.Templates.Components.Data.HeatPump datHeaPumRevRed(
    final typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    final is_rev=true,
    final typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit,
    mHeaWat_flow_nominal=datHeaPumRevRed.capHea_nominal/abs(Buildings.Templates.Data.Defaults.THeaWatSupMed
         - Buildings.Templates.Data.Defaults.THeaWatRetMed)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWat_nominal=Buildings.Templates.Data.Defaults.dpConWatChi,
    capHea_nominal=500E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    mChiWat_flow_nominal=datHeaPumRevRed.capCoo_nominal/abs(Buildings.Templates.Data.Defaults.TChiWatSup
         - Buildings.Templates.Data.Defaults.TChiWatRet)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCoo_nominal=500E3,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    redeclare
      Buildings.Fluid.HeatPumps.Data.EquationFitReversible.Trane_Axiom_EXW240
      perFit)
    "Parameters for reversible AWHP using performance data record redeclaration"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  parameter Buildings.Templates.Components.Data.HeatPump datHeaPumNonRevLoc(
    perFit(hea(
        P=datHeaPumNonRevLoc.capHea_nominal/Buildings.Templates.Data.Defaults.COPHeaPumAirWatHea,
        coeQ={-4.2670305442,-0.7381077035,6.0049480456,0,0},
        coeP={-4.9107455513,5.3665308366,0.5447612754,0,0},
        TRefLoa=Buildings.Templates.Data.Defaults.THeaWatRetMed,
        TRefSou=Buildings.Templates.Data.Defaults.TOutHeaPumHeaHig)),
    final typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    final is_rev=false,
    final typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit,
    mHeaWat_flow_nominal=datHeaPumNonRevLoc.capHea_nominal/abs(Buildings.Templates.Data.Defaults.THeaWatSupMed
         - Buildings.Templates.Data.Defaults.THeaWatRetMed)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWat_nominal=Buildings.Templates.Data.Defaults.dpConWatChi,
    capHea_nominal=500E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed)
    "Parameters for non-reversible AWHP using local assignment of the performance curves"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/HeatPumpsRecord.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=3000),
    Documentation(
      info="<html>
FIXME: Maybe remove this validation model, not very useful.
<p>
This model validates the parameter propagation within the record class
<a href=\"modelica://Buildings.Templates.Components.Data.HeatPump\">
Buildings.Templates.Components.Data.HeatPump</a>.
It illustrates
</p>
<ul>
<li>
how to assign a value to the performance curves either manually 
(<code>datHeaPumNonRevLoc.hea</code>) or by means of a record 
redeclaration (<code>datHeaPumRevRed.per</code>) or record binding 
(<code>datHeaPumRevAss.per</code>),
</li>
<li>
how the original bindings for design parameters such as the 
HW flow rate and capacity do not persist when redeclaring the performance record
<code>datHeaPumRevRed.per</code> or reassigning it (<code>datHeaPumRevAss.per</code>).
</li>
</ul>
</html>"));
end DataRecord;
