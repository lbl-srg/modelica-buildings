within Buildings.Templates.Plants.Chillers.Validation;
model HardCase2FromDp "Validation of chiller plant template"
  extends Buildings.Templates.Plants.Chillers.Validation.HardCase2(
    pla(intChi(valChiWatChiBypPar(from_dp=true))))
  annotation(IconMap(primitivesVisible = false));
annotation(experiment(Tolerance=1e-6,
  StopTime=86400.0,
  __Dymola_Algorithm="Cvode"), Documentation(info="Warning: The following was detected at time: 0
  In HardCase2FromDp.pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiRat: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiRat.index > 0 and pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiRat.index <= 2

Warning: The following was detected at time: 0
  In HardCase2FromDp.pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiMaxFlo: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiMaxFlo.index > 0 and pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiMaxFlo.index <= 2

Warning: The following was detected at time: 0
  In HardCase2FromDp.pla.ctl.ctl.upProCon.minChiWatFlo.nexChiRat: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.upProCon.minChiWatFlo.nexChiRat.index > 0 and pla.ctl.ctl.upProCon.minChiWatFlo.nexChiRat.index <= 2

Warning: The following was detected at time: 0
  In HardCase2FromDp.pla.ctl.ctl.upProCon.minChiWatFlo.nexChiMaxFlo: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.upProCon.minChiWatFlo.nexChiMaxFlo.index > 0 and pla.ctl.ctl.upProCon.minChiWatFlo.nexChiMaxFlo.index <= 2

Warning: The following was detected at time: 0
  In HardCase2FromDp.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2

Model: Buildings.Templates.Plants.Chillers.Validation.HardCase2FromDp
Integration started at 0 using integration method:
cvode from sundials

Warning: The following was detected at time: 37800
  In HardCase2FromDp.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2

Warning: The following was detected at time: 70453.80227431573
  In HardCase2FromDp.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2

Warning: The following was detected at time: 71414.3621580614
  In HardCase2FromDp.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2

Warning: The following was detected at time: 74073.82786365463
  In HardCase2FromDp.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2


Integration terminated successfully at T = 86400
   CPU-time for integration                  : 9.36535 seconds
   CPU-time for initialization               : 0.372528 seconds
   Number of result points                   : 3499
   Number of grid points                     : 501
   Number of accepted steps                  : 23884
   Number of rejected steps                  : 1346
   Number of f-evaluations (dynamics)        : 37432
   Number of non-linear iteration            : 34584
   Number of non-linear convergence failures : 784
   Number of Jacobian-evaluations            : 1756
   Number of crossing function evaluations   : 29744
   Number of model time events               : 1018
   Number of state events                    : 491
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.Chillers.Validation.HardCase2FromDp"));
end HardCase2FromDp;
