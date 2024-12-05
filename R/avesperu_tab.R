#' aves_peru_2024 Dataset
#'
#' The aves_peru_2024 dataset contains a tibble that provides information on bird
#' species recorded in Peru, based on the "List of the Birds of Peru" by M. A. Plenge
#' (last updated on March 6, 2024). It includes details such as scientific names,
#' English names, Spanish names, order, family, and status of each species.
#'
#' @format A tibble with 1,901 rows and 6 columns:
#'   \describe{
#'     \item{scientific_name}{Scientific name of the bird species.}
#'     \item{english_name}{English common name of the bird species.}
#'     \item{spanish_name}{Spanish common name of the bird species.}
#'     \item{order}{The order to which the bird species belongs.}
#'     \item{family}{The family to which the bird species belongs.}
#'     \item{status}{Status of the bird species (e.g., resident, endemic,
#'     migratory, etc.).}
#'   }
#'
#'
#' @details This dataset is designed to provide users with comprehensive
#' information about the avian species found in Peru, as documented
#' by M. A. Plenge. It is organized for easy access and utilization within
#' the R environment.
#'
#' @examples
#' # Load the avesperu package
#' library(avesperu)
#'
#' # Access the avesperu_tab dataset
#' data("aves_peru_2024")
#'
#' # Display the first few rows
#' head(aves_peru_2024)
#'
#' @seealso
#' For more information about the "avesperu" package and the data sources, visit
#' the package's GitHub repository: \url{https://github.com/PaulESantos/avesperu}
#'
#' @references
#' The dataset is based on the "List of the Birds of Peru" by M. A. Plenge.
#' The citation for the list is as follows:
#' Plenge, M. A. Version (09-03-2024). List of the birds of Peru / Lista de las aves del Perú.
#' Unión de Ornitólogos del Perú: https://sites.google.com/site/boletinunop/checklist
#'
#' @author
#' Data compilation: M. A. Plenge, Package implementation: Paul Efren Santos Andrade
#'
#' @keywords dataset
"aves_peru_2024"
