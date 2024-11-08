;;; my-holidays.el --- New Zealand calendar holidays  -*- lexical-binding: t; -*-

;; DEBUG: (co 'calendar-holidays)

;; Copyright (C) 2024  Phil Sainty

;; Author: Phil Sainty <phil@catalyst.net.nz>
;; Keywords: local

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; NZ Holidays.

;; Reference: https://publicholiday.co.nz/

;; You need to load this before holidays.el gets loaded, which may
;; happen in a number of ways (for example, `appt-activate' causes
;; the whole appt, diary-lib, calendar, and holidays suite to be
;; loaded).

;; Alternatively, if you (customize-option 'calendar-holidays)
;; then you can probably get a fixed value without holidays.el
;; overriding it, but we do not assume that is the case here.
;;
;; N.b. If you are making changes to your holiday config and not
;; seeing your changes reflected in the front-end, customizing
;; `calendar-holidays' is the usual fix for that as well.  Use
;; the "Revert..." => "Erase Customizations" option, and the list
;; will be rebuilt.

;; Solar time, `calendar-latitude', and `calendar-longitude':
;;
;; You should configure these in your init file, so that the calendar
;; functions for solar events know at least approximately where you
;; are located (and especially which hemisphere you are in).
;;
;; An example configuration for Wellingon NZ is:
;;
;; ;; See `solar-setup'.
;; ;; (Note that `calendar-time-zone' should be set by default.)
;; (setq calendar-latitude -41.257083
;;       calendar-longitude 174.865611)
;; ;; 41°15'25.5"S,174°51'56.2"E

;; TODO: The defaults do not bump the Xmas and New Year holiday dates
;; around weekends.  E.g. 25 December 2022 was a Sunday, so public
;; holidays should be Monday the 26th (Boxing Day) and Tuesday the
;; 27th (Xmas deferred).
;;
;; The same applies for New Year's Day & The Day After New Year's Day.
;;
;; These two resolution-loaded holidays are always celebrated on the 1st
;; and 2nd of January, however, if one or both of these holidays lands on
;; a weekend, the holiday is actually observed on the next available
;; working weekday.
;;
;; For example, in 2012 New Year's Day landed on a Sunday. The day the
;; holiday was observed couldn't be Monday as this was already taken up
;; by the Day after New Year's Day holiday so instead it was pushed to
;; Tuesday the 3rd of January.
;;
;; (A)ctual => (O)bserved for pairs of consecutive holidays:
;; D1: Fri => D1+0(A), D2+2(O)
;; D1: Sat => D1+2(O), D2+2(O)
;; D1: Sun => D1+2(O), D2+0(A)

;; TODO: Consider implementing the Māori lunar calendar.  One problem is that
;; aspects vary across the country -- there's no single comprehensive version?
;; https://www.youtube.com/watch?v=uBisUbuGMNA says 400+ at one point, so that
;; is utterly impractical for me to attempt, even if they are all documented.
;;
;; However... there's a manual dial implemented here which we can most certainly
;; reproduce in lisp (leveraging the existing lunar.el), and it seems to have
;; just two modes:
;; https://thespinoff.co.nz/atea/07-08-2018/move-over-astrology-its-time-to-return-to-the-maori-lunar-calendar
;; If it's only a matter of whether you're on the West coast or the East coast
;; then `calendar-latitude' and `calendar-longitude' could be used to establish
;; that... so it's probably do-able to that extent, at minimum!  Might be a fun
;; thing to work on.

;; > In principle, yes, it's useful to have a calendar that is linked to the
;; > maramataka. It is very localised so there are different names for different
;; > nights depending on where you are in the country. The general east/west
;; > divide could be a good place to start however I'm wondering if showing the
;; > moon phase instead could be a better option?
;;
;; > The lunar phase is only part of what is going on - there's also what the
;; > stars are doing, the environment, the tides etc. So having the lunar phase
;; > is a piece of the puzzle (which would mean I wouldn't have to check
;; > https://www.timeanddate.com/moon/phases/new-zealand/wellington ).
;;
;; > When I did the Tuhituhi communications course they suggested people start
;; > with the main moon phases (as above) so even only the major phases would be
;; > useful.

;; N.B. The following diary entries already provide lunar and solar info:
;;
;; %%(diary-lunar-phases)
;; %%(diary-sunrise-sunset)
;;
;; That is limited to the dates of major lunar phases; those shown by:
;; M-x lunar-phases (but we could make it more detailed; and maybe a SVG
;; in the mode line would be a neat addition).
;;
;; `lunar-phase-names' is only:
;; ("New Moon" "First Quarter Moon" "Full Moon" "Last Quarter Moon")
;;
;; 🌑	NEW MOON SYMBOL
;; 🌒	WAXING CRESCENT MOON SYMBOL
;; 🌓	FIRST QUARTER MOON SYMBOL
;; 🌔	WAXING GIBBOUS MOON SYMBOL
;; 🌕	FULL MOON SYMBOL
;; 🌖	WANING GIBBOUS MOON SYMBOL
;; 🌗	LAST QUARTER MOON SYMBOL
;; 🌘	WANING CRESCENT MOON SYMBOL
;;
;; For NZ, down in the Southern hemisphere, these unicode characters need to be
;; flipped horizontally.  Best would be SVGs generated dynamically according to
;; `calendar-latitude' (i.e. how close you are to the equator), as the image
;; rotates through a full 180-degrees depending on where you are.

;; https://www.rasnz.org.nz/in-the-sky/lunar-phases-1
;; https://astronomy.stackexchange.com/questions/24711/how-does-the-moon-look-like-from-different-latitudes-of-the-earth

;; Note that the holidays library requires dates to be specified in
;; U.S.-style (MONTH DAY) order, and uses zero as the ordinal value
;; for Sunday.

;;; Code:

;; Silence byte-compilation warnings.
(defvar calendar-latitude)
(defvar calendar-longitude)
(defvar calendar-mark-holidays-flag)
(defvar diary-show-holidays-flag)
(defvar displayed-month)
(defvar displayed-year)
(defvar holiday-bahai-holidays)
(defvar holiday-christian-holidays)
(defvar holiday-general-holidays)
(defvar holiday-hebrew-holidays)
(defvar holiday-islamic-holidays)
(defvar holiday-oriental-holidays)
(defvar holiday-solar-holidays)
(with-suppressed-warnings ((lexical year)) (defvar year))
(declare-function calendar-absolute-from-gregorian "calendar")
(declare-function calendar-gregorian-from-absolute "calendar")
(declare-function calendar-date-is-visible-p "calendar")
(declare-function calendar-day-of-week "calendar")
(declare-function holiday-easter-etc "holidays")
(declare-function holiday-fixed "holidays")
(declare-function holiday-float "holidays")

;; Configure variables which will affect `calendar-holidays'.
;; n.b. This /must/ be done before holidays.el is loaded.
;;
;; Alternatively, you could customize these variables (but again,
;; ensure they're set prior to holidays.el being loaded).
;;
;; Note that the "general" holidays are all U.S.-centric and they are
;; either wrong for NZ, or likely not very useful to display.  (The
;; ones which are the same in NZ have been copied to the NZ lists.)
;;
;; Hide most categories entirely.
(setq holiday-general-holidays nil
      holiday-bahai-holidays nil
      holiday-christian-holidays nil
      holiday-hebrew-holidays nil
      holiday-islamic-holidays nil
      holiday-oriental-holidays nil
      ;; holiday-solar-holidays nil
      )

;; (defvar my-holidays-exclude
;;   '((holiday-general-holidays
;;      ;; The following are all U.S.-centric and they are either wrong
;;      ;; for NZ (in which case we replace them), or else I didn't think
;;      ;; they were useful to display (but YMMV, so adjust as you see fit).
;;      . ("President's Day"
;;         "Memorial Day"
;;         "Flag Day"
;;         "Independence Day"
;;         "Columbus Day"
;;         "Veteran's Day"
;;         "Thanksgiving"
;;         ;; We replace these with the NZ equivalents.
;;         "Mother's Day"
;;         "Father's Day"
;;         "Labor Day"
;;         )))
;;   "U.S.-centric holidays to be ignored (or replaced).")
;;
;; (defun my-holidays-config ()
;;   "Prune standard holiday lists using `my-holidays-exclude'.
;;
;; This doesn't actually work, as `calendar-holidays' has already
;; been updated, and changing one of its source lists after the
;; fact has no effect without rebuilding the main list.
;;
;; We /could/ target `calendar-holidays' when removing items,
;; but there's some potential for conflict there.
;;
;; It's simplest to just clobber it entirely."
;;   (dolist (category (mapcar #'car my-holidays-exclude))
;;     (let ((exclusions (alist-get category my-holidays-exclude)))
;;       (set category (cl-delete-if (lambda (key)
;;                                     (member (car key) exclusions))
;;                                   (custom--standard-value category)
;;                                   :key #'last)))))
;;
;; (with-eval-after-load "holidays"
;;   (my-holidays-config))

(defun my-holidays-date-offset (date offset)
  "Add OFFSET days to DATE (month day year), returning the new date."
  ;; Like `calendar-current-date', but for arbitrary date.
  (if (zerop offset)
      date
    (calendar-gregorian-from-absolute
     (+ offset (calendar-absolute-from-gregorian date)))))

(defun my-holidays-closest-day-offset (from to)
  "Return the smallest distance (-3 to 3) between FROM and TO.

Each argument is an integer from 0 (Sunday) to 6 (Saturday).

See also `my-holidays-closest-date-to-dow'."
  ;;              0  1  2  3  4  5  6
  ;;       From:  S  M  T  W  T  F  Sat   ; To:
  (aref (aref [[  0 -1 -2 -3  3  2  1 ]   ; 0 Sunday
               [  1  0 -1 -2 -3  3  2 ]   ; 1 Monday
               [  2  1  0 -1 -2 -3  3 ]   ; 2 Tuesday
               [  3  2  1  0 -1 -2 -3 ]   ; 3 Wednesday
               [ -3  3  2  1  0 -1 -2 ]   ; 4 Thursday
               [ -2 -3  3  2  1  0 -1 ]   ; 5 Friday
               [ -1 -2 -3  3  2  1  0 ]]  ; 6 Saturday
              to)
        from))
;; Or this, which is shorter, but less-obvious, and no quicker.
;; (aref [1 2 3 -3 -2 -1 0 1 2 3 -3 -2 -1] (+ 6 (- to from)))
;;                       ^
;;                       `-- the +6 meaning we start here.

(defun my-holidays-closest-date-to-dow (dow month day &optional string)
  "This is for holidays which are always on a particular day of
the week (DOW), closest to the specified DAY of the MONTH.

DOW is an integer from 0 (Sunday) to 6 (Saturday).

The resulting date may be before or after the original date."
  (let* ((date (list month day year))
         (datedow (calendar-day-of-week date))
         (offset (my-holidays-closest-day-offset datedow dow))
         (newdate (my-holidays-date-offset date offset)))
    (and (calendar-date-is-visible-p newdate)
         (list (list newdate string)))))

(defun my-holidays-closest-monday (month day &optional string)
  "This is for holidays which are always on the closest Monday to the
specified DAY of the MONTH."
  (let ((year displayed-year))
    (my-holidays-closest-date-to-dow 1 month day string)))

(defun my-holidays-closest-friday (month day &optional string)
  "This is for holidays which are always on the closest Friday to the
specified DAY of the MONTH."
  (let ((year displayed-year))
    (my-holidays-closest-date-to-dow 5 month day string)))

;; TODO:
;; Convert this to a generic "next DAY after DATE".
;; and add an analogous "previous DAY before DATE".

(defun my-holidays-weekend-to-monday (month day &optional string only-weekend)
  "This is for holidays which shift to the following Monday if the
specified DAY of the MONTH lands on a weekend.

If ONLY-WEEKEND is non-nil, return nil if DAY MONTH is a week day."
  (when-let* ((year displayed-year)
              (date (list month day year))
              (offset (cl-case (calendar-day-of-week date)
                        (6 2) ;; Saturday + 2 days = Monday
                        (0 1) ;; Sunday + 1 day = Monday
                        (t (if only-weekend nil 0))))
              (newdate (my-holidays-date-offset date offset)))
    (and (calendar-date-is-visible-p newdate)
         (list (list newdate string)))))

(defun my-holidays-weekend-to-friday (month day &optional string only-weekend)
  "This is for holidays which shift to the preceding Friday if the
specified DAY of the MONTH lands on a weekend.

If ONLY-WEEKEND is non-nil, return nil if DAY MONTH is a week day."
  (when-let* ((year displayed-year)
              (date (list month day year))
              (offset (cl-case (calendar-day-of-week date)
                        (6 -1) ;; Saturday - 1 day = Friday
                        (0 -2) ;; Sunday -2 days = Friday
                        (t (if only-weekend nil 0))))
              (newdate (my-holidays-date-offset date offset)))
    (and (calendar-date-is-visible-p newdate)
         (list (list newdate string)))))

(defun my-holidays-matariki (&optional string)
  "Matariki is a Friday in June or July.

It is non-trivial to calculate the specific date.  Refer to:

- URL `https://teara.govt.nz/en/matariki-te-tau-hou-maori/page-1'
- URL `https://teara.govt.nz/en/matariki-maori-new-year/page-3'

Instead, we're using the the table provided by the Matariki
Advisory Committee, which covers the years from 2022 to 2052:

- URL `https://www.mbie.govt.nz/assets/matariki-dates-2022-to-2052-matariki-advisory-group.pdf'
- URL `https://www.mbie.govt.nz/business-and-employment/employment-and-skills/employment-legislation-reviews/matariki/matariki-public-holiday'"
  (when-let* ((year displayed-year)
              (dates '((2022 06 24) (2023 07 14) (2024 06 28) (2025 06 20)
                       (2026 07 10) (2027 06 25) (2028 07 14) (2029 07 06)
                       (2030 06 21) (2031 07 11) (2032 07 02) (2033 06 24)
                       (2034 07 07) (2035 06 29) (2036 07 18) (2037 07 10)
                       (2038 06 25) (2039 07 15) (2040 07 06) (2041 07 19)
                       (2042 07 11) (2043 07 03) (2044 06 24) (2045 07 07)
                       (2046 06 29) (2047 07 19) (2048 07 03) (2049 06 25)
                       (2050 07 15) (2051 06 30) (2052 06 21)))
              (ymd (assoc year dates))
              (newdate (cl-destructuring-bind (year month day) ymd
                         (list month day year))))
    (and (calendar-date-is-visible-p newdate)
         (list (list newdate string)))))

(defun my-holidays-labour-day ()
  "Labour Day is the 4th Monday in October."
  ;; Labour Day is the basis for multiple holidays, so we cache it here so that
  ;; we do not need to repeatedly re-caclculate it.  This cache never expires
  ;; (for the lifetime of the Emacs session), so in theory it could grow large;
  ;; but you'd need to be doing something *very* strange for that to ever happen
  ;; in practice.
  (when-let* ((cache (or (get 'my-holidays-labour-day 'labour-day-cache)
                         (put 'my-holidays-labour-day 'labour-day-cache '(t))))
              ;; (put 'my-holidays-labour-day 'labour-day-cache nil)
              (mnths (or (alist-get displayed-year (cdr cache))
                         (setf (alist-get displayed-year (cdr cache))
                               (make-vector 13 t)))) ;; t means unknown.
              (value (aref mnths displayed-month))
              (holiday (cond ((eq value t) ;; Calculate for the year/month.
                              (aset mnths displayed-month
                                    (holiday-float 10 1 4 "Labour Day")))
                             (t ;; Either nil or a holiday.
                              value))))
    ;; Copy the date so that callers cannot modify the cached value.
    (cl-destructuring-bind ((date string))
        holiday
      (list (list (copy-sequence date) string)))))

;; Should I use `calendar-date-is-visible-p' here, on top of `holiday-float'
;; doing that job?  And if so... should I even be caching this per-month, or
;; should I just hard-code the known month for the look-up and then use the
;; predicate at the end to decide what to return?

(defun my-holidays-hawkes-bay-anniversary ()
  "Hawke's Bay Anniversary is observed on the Friday before Labour Day."
  ;; Labour Day is the 4th Monday in October, and so we simply want the date which
  ;; is 3 days earlier than that.  As the new date is guaranteed to be in the same
  ;; month, the calculation can be a trivial subtraction.
  (when-let ((date (caar (my-holidays-labour-day))))
    (cl-decf (cadr date) 3)
    (list (list date "Hawke's Bay Anniversary"))))

(defun my-holidays-marlborough-anniversary ()
  "Marlborough Anniversary is observed on the Monday after Labour Day."
  ;; Labour Day is the 4th Monday in October, so the new date is simply 7 days
  ;; later.  (That may be in November, so set `displayed-month' to October for
  ;; the Labour Day lookup.)
  (when-let* ((date (caar (let ((displayed-month 10))
                            (my-holidays-labour-day))))
              (newdate (calendar-gregorian-from-absolute
                        (+ 7 (calendar-absolute-from-gregorian date)))))
    (and (calendar-date-is-visible-p newdate)
         (list (list newdate "Marlborough Anniversary")))))

(defun my-holidays-canterbury-anniversary ()
  "Canterbury anniversary is observed on the Fri. after 2nd Tue. in November."
  ;; The source description is "observed on the second Friday after
  ;; the first Tuesday in November" which is simply that initial date
  ;; plus 10 days, in the same month.  This can, of course, also be
  ;; written as the 1st Friday after the 2nd Tuesday in November,
  ;; which was better for achieving a one-line docstring.)
  (when-let ((date (caar (holiday-float 11 2 1 "1st Tuesday in November"))))
    (cl-incf (cadr date) 10)
    (list (list date "Canterbury Anniversary"))))

;; NZ public holidays.
(setq holiday-local-holidays
      '((holiday-fixed 01 01 "New Year's Day")
        (holiday-fixed 01 02 "Day After New Year")
        (holiday-fixed 02 06 "Waitangi Day")
        (my-holidays-weekend-to-monday 02 06 "Waitangi Day (holiday)" t)
        (holiday-easter-etc -2 "Good Friday")
        (holiday-easter-etc 1 "Easter Monday")
        (holiday-fixed 04 25 "ANZAC Day")
        (my-holidays-weekend-to-monday 04 25 "ANZAC Day (holiday)" t)
        (holiday-float 06 1 1 "King's Birthday") ;; 1st Monday in June
        (my-holidays-matariki "Matariki") ;; A Friday in June or July
        (my-holidays-labour-day) ;; 4th Monday in October
        (holiday-fixed 12 25 "Christmas Day")
        (holiday-fixed 12 26 "Boxing Day")

        ;; Regional Anniversary Days (observed holiday dates):
        (holiday-easter-etc 2 "Southland Anniversary") ;; Easter Tuesday
        (my-holidays-closest-monday 01 22 "Wellington Anniversary")
        (my-holidays-closest-monday 01 29 "Auckland Anniversary")
        (my-holidays-closest-monday 02 01 "Nelson Anniversary")
        (my-holidays-closest-monday 03 23 "Otago Anniversary")
        (holiday-float 03 1 2 "Taranaki Anniversary") ;; 2nd Monday of March
        (my-holidays-hawkes-bay-anniversary) ;; Friday before Labour Day
        (my-holidays-marlborough-anniversary) ;; 1st Monday after Labour Day
        (my-holidays-canterbury-anniversary) ;; 2nd Friday after 1st Tuesday in November
        (my-holidays-closest-monday 11 30 "Chatham Islands Anniversary")
        (my-holidays-closest-monday 12 01 "Westland Anniversary")
        (holiday-float 09 1 4 "South Canterbury Anniversary") ;; 4th Monday in September
        ;; ;; Regional Anniversary Days (actual dates):
        ;; (holiday-fixed 01 17 "Southland Anniversary (actual)") ;; Observed on Easter Tuesday.
        ;; (holiday-fixed 01 22 "Wellington Anniversary (actual)") ;; Observed on closest Monday
        ;; (holiday-fixed 01 29 "Auckland Anniversary (actual)") ;; Observed on closest Monday
        ;; (holiday-fixed 02 01 "Nelson Anniversary (actual)") ;; Observed on closest Monday
        ;; (holiday-fixed 03 23 "Otago Anniversary (actual)") ;; Observed on closest Monday
        ;; (holiday-fixed 03 31 "Taranaki Anniversary (actual)") ;; Observed on the 2nd Monday of March
        ;; (holiday-fixed 11 01 "Hawke's Bay Anniversary (actual)") ;; Observed on the Friday before Labour Day
        ;; (holiday-fixed 11 01 "Marlborough Anniversary (actual)") ;; Observed on 1st Monday after Labour Day
        ;; (holiday-fixed 11 30 "Chatham Islands Anniversary (actual)") ;; Observed on closest Monday
        ;; (holiday-fixed 12 01 "Westland Anniversary (actual)") ;; Observed on closest Monday
        ;; (holiday-fixed 12 16 "Canterbury Anniversary (actual)") ;; Observed on 2nd Friday after 1st Tuesday in November.
        ;; (holiday-fixed 12 16 "South Canterbury Anniversary (actual)") ;; Observed on 4th Monday in September
        ))

;; Other NZ dates of note.
(setq holiday-other-holidays
      '((holiday-fixed 02 14 "Valentine's Day")
        (holiday-fixed 03 17 "St. Patrick's Day")
        (holiday-fixed 04 01 "April Fools' Day")
        (holiday-float 05 0 2 "Mother's Day") ;; 2nd Sunday in May.
        (holiday-float 09 0 1 "Father's Day") ;; 1st Sunday in September.
        (holiday-fixed 10 31 "Halloween")))


(provide 'my-holidays)
