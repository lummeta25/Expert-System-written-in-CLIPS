(deftemplate MAIN::patient
   (slot name)
   (slot weight)
   (slot height)
   (slot blurred-vision)
   (slot tiredness)
   (slot BMI)
   (slot age)
   (slot family-history)
   (slot fasting-blood-sugar)
   (slot low-physical-activity)
   (slot number-of-pregnancies))

(defrule MAIN::calculate-BMI
   ?f <- (patient (name ?n) (weight ?w) (height ?h) (BMI ?b&:(= ?b 0.0)))
   =>
   (bind ?calculated-bmi (/ ?w (* ?h ?h)))
   (modify ?f (BMI ?calculated-bmi)))

(defrule MAIN::diagnosis
   (patient (name ?n) (age ?a) (weight ?w) (blurred-vision ?bv) (tiredness ?t) (BMI ?bmi) (family-history ?fh) (fasting-blood-sugar ?fbs) (low-physical-activity ?lpa) (number-of-pregnancies ?nop))
   =>
   (bind ?count 0)
   (if (> ?a 25)
      then
      (bind ?count (+ ?count 1)))
   (if (eq ?bv yes)
      then
      (bind ?count (+ ?count 1)))
   (if (eq ?t yes)
      then
      (bind ?count (+ ?count 1)))
   (if (> ?bmi 28)
      then
      (bind ?count (+ ?count 1)))
   (if (eq ?fh yes)
      then
      (bind ?count (+ ?count 1)))
   (if (>= ?fbs 126)
      then
      (bind ?count (+ ?count 1)))
   (if (eq ?lpa yes)
      then
      (bind ?count (+ ?count 1)))
   (if (>= ?nop 3)
      then
      (bind ?count (+ ?count 1)))
   (assert (symptom-count ?count))
   (if (> ?count 5)
      then
      (printout t "Patient " ?n " has a high risk of diabetes (symptom count: " ?count ")." crlf)))

