#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════════════════
#  ENHANCED BUG BOUNTY RECONNAISSANCE SUITE v4.0
#  Professional subdomain enumeration and vulnerability scanning
# ═══════════════════════════════════════════════════════════════════════════

set -Eeuo pipefail
trap 'log_error "Script interrupted at line $LINENO"' ERR INT TERM

# ═══════════════════════════════════════════════════════════════════════════
#  ENVIRONMENT & CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════

export PATH="/usr/local/bin/recon-tools:$HOME/go/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
ulimit -n 8192 2>/dev/null || true

# Color Palette - Hacker Theme (Matrix Style)
readonly RED='\033[0;31m'
readonly BRIGHT_RED='\033[1;31m'
readonly GREEN='\033[0;32m'
readonly BRIGHT_GREEN='\033[1;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly GRAY='\033[0;90m'
readonly BLACK='\033[0;30m'
readonly BOLD='\033[1m'
readonly DIM='\033[2m'
readonly BLINK='\033[5m'
readonly NC='\033[0m'

# Icons
readonly ICON_SKULL="☠"
readonly ICON_HACK="⚡"
readonly ICON_TARGET="🎯"
readonly ICON_SCAN="👁"
readonly ICON_ALERT="⚠"
readonly ICON_LOCK="🔐"
readonly ICON_EXPLOIT="💀"
readonly ICON_DATA="📡"

# ═══════════════════════════════════════════════════════════════════════════
#  LOGGING & UI FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

print_banner() {
    clear
    echo -e "${BRIGHT_GREEN}${BOLD}"
    cat << "EOF"
    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
    ███████████████████████████████████████████████████████████████████████████
    ██                                                                       ██
    ██   ██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗    ███████╗██╗   ██╗ ██
    ██   ██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║    ██╔════╝╚██╗ ██╔╝ ██
    ██   ██████╔╝█████╗  ██║     ██║   ██║██╔██╗ ██║    ███████╗ ╚████╔╝  ██
    ██   ██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╗██║    ╚════██║  ╚██╔╝   ██
    ██   ██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚████║    ███████║   ██║    ██
    ██   ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝    ╚══════╝   ╚═╝    ██
    ██                                                                       ██
EOF
    echo -e "    ██${BRIGHT_RED}           ☠  ADVANCED RECONNAISSANCE FRAMEWORK  ☠            ${BRIGHT_GREEN}██"
    echo -e "    ██${WHITE}              Coded by: ${BRIGHT_GREEN}Mr.Beka${WHITE} | v4.0 ELITE             ${BRIGHT_GREEN}██"
    echo -e "    ██                                                                       ██"
    echo -e "    ███████████████████████████████████████████████████████████████████████████"
    echo -e "    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${NC}"
    echo ""
    echo -e "${BRIGHT_RED}    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${NC}"
    echo -e "${BRIGHT_RED}    ┃${NC} ${BRIGHT_GREEN}TARGET:${NC}      ${BRIGHT_RED}$1${NC}"
    echo -e "${BRIGHT_RED}    ┃${NC} ${BRIGHT_GREEN}TIMESTAMP:${NC}   ${WHITE}$(date +'%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${BRIGHT_RED}    ┃${NC} ${BRIGHT_GREEN}OUTPUT DIR:${NC}  ${DIM}$2${NC}"
    echo -e "${BRIGHT_RED}    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
    echo ""
}

log_phase() {
    echo ""
    echo -e "${BRIGHT_RED}${BOLD}    ╔══════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BRIGHT_RED}${BOLD}    ║${NC}  ${BRIGHT_GREEN}$1${NC}"
    echo -e "${BRIGHT_RED}${BOLD}    ╚══════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

log_info() {
    echo -e "${BRIGHT_GREEN}    [${ICON_DATA}]${NC} ${WHITE}$1${NC}"
}

log_success() {
    echo -e "${BRIGHT_GREEN}    [${ICON_HACK}] ${BOLD}SUCCESS${NC} ${BRIGHT_GREEN}»${NC} $1"
}

log_warn() {
    echo -e "${BRIGHT_RED}    [${ICON_ALERT}] ${BOLD}WARNING${NC} ${BRIGHT_RED}»${NC} $1"
}

log_error() {
    echo -e "${BRIGHT_RED}${BOLD}    [${ICON_SKULL}] FATAL ERROR${NC} ${BRIGHT_RED}»${NC} $1" >&2
    exit 1
}

log_progress() {
    echo -e "${BRIGHT_GREEN}    [${ICON_SCAN}]${NC} ${DIM}$1${NC}"
}

print_divider() {
    echo -e "${BRIGHT_GREEN}    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════
#  DEPENDENCY CHECKS
# ═══════════════════════════════════════════════════════════════════════════

check_dependencies() {
    log_info "Verifying required tools..."

    local missing_tools=()
    local tools=("subfinder" "assetfinder" "httpx" "nuclei" "waybackurls" "curl" "jq")

    # Note: optional tools like pageres are validated based on selected features (fallbacks)

    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done

    if [ ${#missing_tools[@]} -gt 0 ]; then
        log_error "Missing required tools: ${missing_tools[*]}\nPlease install them (apt/brew/go install) or add them to your PATH"
    fi

    # Quick connectivity check
    if ! curl -s --connect-timeout 5 -I https://google.com > /dev/null 2>&1; then
        log_warn "Internet connectivity issue detected - some tools may fail"
    fi

    log_success "All dependencies verified"
}

# ═══════════════════════════════════════════════════════════════════════════
#  ARGUMENT PARSING & SETUP (now with flags)
# ═══════════════════════════════════════════════════════════════════════════

# Defaults
MODE="fast"             # fast, balanced, deep
BASE_DIR="$HOME/Desktop/BugBounty"
SCREENSHOT_TOOL="auto"   # auto|gowitness|pageres
SCREENSHOT_COUNT_LIMIT=""
VERBOSE=0

print_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Required:
  -t, --target <domain>        Target domain (example.com)

Options:
  -m, --mode <fast|balanced|deep>   Scan mode (default: fast)
  -o, --outdir <path>               Base output dir (default: $HOME/Desktop/BugBounty)
  -s, --screenshot <auto|gowitness|pageres>  Screenshot engine (default: auto)
  -n, --screenshot-limit <N>        Max screenshots to capture (overrides mode default)
  -v, --verbose                     Enable verbose logging
  -h, --help                        Show this help and exit

Examples:
  $0 -t example.com -m deep
  $0 --target example.com --screenshot pageres --screenshot-limit 5
EOF
}

# Parse flags (supports long and short options)
ARGS=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--target)
            TARGET="$2"; shift 2;;
        -m|--mode)
            MODE="$2"; shift 2;;
        -o|--outdir)
            BASE_DIR="$2"; shift 2;;
        -s|--screenshot)
            SCREENSHOT_TOOL="$2"; shift 2;;
        -n|--screenshot-limit)
            SCREENSHOT_COUNT_LIMIT="$2"; shift 2;;
        -v|--verbose)
            VERBOSE=1; shift 1;;
        -h|--help)
            print_usage; exit 0;;
        --)
            shift; break;;
        -*|--*)
            echo "Unknown option: $1"; print_usage; exit 1;;
        *)
            ARGS+=("$1"); shift;;
    esac
done

# Allow target to be supplied as first positional argument for backward compatibility
if [[ -z "${TARGET:-}" && ${#ARGS[@]} -gt 0 ]]; then
    TARGET="${ARGS[0]}"
fi

if [[ -z "${TARGET:-}" ]]; then
    echo -e "${BRIGHT_RED}${BOLD}"
    echo "    ╔════════════════════════════════════════════════════════════════════╗"
    echo "    ║                         USAGE ERROR                                ║"
    echo "    ╚════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    print_usage
    exit 1
fi

# Validate domain format
if ! [[ "$TARGET" =~ ^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]?\.[a-zA-Z]{2,}$ ]]; then
    log_error "Invalid domain format: $TARGET"
fi

# If user supplied an explicit screenshot limit, coerce into integer
if [[ -n "$SCREENSHOT_COUNT_LIMIT" ]]; then
    if [[ "$SCREENSHOT_COUNT_LIMIT" =~ ^[0-9]+$ ]]; then
        SCREENSHOT_COUNT_LIMIT="$SCREENSHOT_COUNT_LIMIT"
    else
        log_warn "Invalid screenshot limit provided; ignoring"
        SCREENSHOT_COUNT_LIMIT=""
    fi
fi

# Convert SCREENSHOT_TOOL to lowercase
SCREENSHOT_TOOL=$(echo "$SCREENSHOT_TOOL" | tr '[:upper:]' '[:lower:]')
if [[ "$SCREENSHOT_TOOL" != "auto" && "$SCREENSHOT_TOOL" != "gowitness" && "$SCREENSHOT_TOOL" != "pageres" ]]; then
    log_error "Invalid screenshot engine: $SCREENSHOT_TOOL"
fi


# Validate domain format
if ! [[ "$TARGET" =~ ^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]?\.[a-zA-Z]{2,}$ ]]; then
    log_error "Invalid domain format: $TARGET"
fi

DATE=$(date +"%Y%m%d_%H%M%S")
BASE_DIR="$HOME/Desktop/BugBounty"
OUT_DIR="$BASE_DIR/${TARGET}_$DATE"

# Create organized directory structure
mkdir -p "$OUT_DIR"/{raw,final,scans,screenshots,logs}

# Initialize log file
LOG_FILE="$OUT_DIR/logs/recon_${DATE}.log"
exec > >(tee -a "$LOG_FILE") 2>&1

print_banner "$TARGET" "$OUT_DIR"
check_dependencies

# Set performance parameters based on mode
    case "$MODE" in
    fast)
        HTTPX_THREADS=200
        HTTPX_TIMEOUT=5
        NUCLEI_RATE_LIMIT=150
        NUCLEI_CONCURRENCY=50
        NUCLEI_TIMEOUT=5
        NUCLEI_HOST_LIMIT=50  # Only scan top 50 hosts
        : ${SCREENSHOT_COUNT_LIMIT:="10"}
        # Fast-mode nuclei quick profile (two-pass)
        NUCLEI_PARALLEL=2            # split hosts and run multiple nuclei processes in parallel
        NUCLEI_QUICK_SEVERITY="high,critical"
        NUCLEI_QUICK_CONCURRENCY=30
        NUCLEI_QUICK_TIMEOUT=5
        SKIP_WAYBACK=true
        SKIP_CRTSH=false
        log_info "⚡ FAST MODE ACTIVATED - Rapid reconnaissance initiated"
        ;;
    deep)
        HTTPX_THREADS=50
        HTTPX_TIMEOUT=15
        NUCLEI_RATE_LIMIT=30
        NUCLEI_CONCURRENCY=15
        NUCLEI_TIMEOUT=15
        NUCLEI_HOST_LIMIT=0  # Scan all hosts
        : ${SCREENSHOT_COUNT_LIMIT:="30"}
        # Deep mode: full template run; parallelized if desired
        NUCLEI_PARALLEL=4
        unset NUCLEI_QUICK_SEVERITY
        SKIP_WAYBACK=false
        SKIP_CRTSH=false
        log_info "💀 DEEP MODE ACTIVATED - Full spectrum attack initialized"
        ;;
    *)  # balanced
        HTTPX_THREADS=100
        HTTPX_TIMEOUT=10
        NUCLEI_RATE_LIMIT=50
        NUCLEI_CONCURRENCY=25
        NUCLEI_TIMEOUT=10
        NUCLEI_HOST_LIMIT=150  # Scan top 150 hosts
        : ${SCREENSHOT_COUNT_LIMIT:="20"}
        # Balanced mode: quick pass then targeted deep if findings
        NUCLEI_PARALLEL=1
        NUCLEI_QUICK_SEVERITY="high,critical"
        NUCLEI_QUICK_CONCURRENCY=25
        NUCLEI_QUICK_TIMEOUT=7
        SKIP_WAYBACK=false
        SKIP_CRTSH=false
        log_info "⚖  BALANCED MODE ACTIVATED - Standard penetration protocol engaged"
        ;;
esac

# Determine screenshot engine availability and selection
GOWITNESS_AVAILABLE=0
PAGERES_AVAILABLE=0
if command -v gowitness >/dev/null 2>&1; then
    GOWITNESS_AVAILABLE=1
fi
if command -v pageres >/dev/null 2>&1; then
    PAGERES_AVAILABLE=1
fi

# Choose effective engine based on user preference and availability
SCREENSHOT_ENGINE="none"
if [ "$SCREENSHOT_TOOL" = "auto" ]; then
    if [ "$GOWITNESS_AVAILABLE" -eq 1 ]; then
        SCREENSHOT_ENGINE="gowitness"
        log_info "Screenshot engine selected: GoWitness"
    elif [ "$PAGERES_AVAILABLE" -eq 1 ]; then
        SCREENSHOT_ENGINE="pageres"
        log_info "Screenshot engine selected: pageres (auto-fallback)"
    else
        log_warn "No screenshot engine available; visual recon will be skipped"
    fi
elif [ "$SCREENSHOT_TOOL" = "gowitness" ]; then
    if [ "$GOWITNESS_AVAILABLE" -eq 1 ]; then
        SCREENSHOT_ENGINE="gowitness"
        log_info "Screenshot engine selected: GoWitness"
    elif [ "$PAGERES_AVAILABLE" -eq 1 ]; then
        SCREENSHOT_ENGINE="pageres"
        log_warn "GoWitness not available; falling back to pageres"
    else
        log_warn "Neither GoWitness nor pageres is available; skipping visual reconnaissance"
    fi
elif [ "$SCREENSHOT_TOOL" = "pageres" ]; then
    if [ "$PAGERES_AVAILABLE" -eq 1 ]; then
        SCREENSHOT_ENGINE="pageres"
        log_info "Screenshot engine selected: pageres"
    elif [ "$GOWITNESS_AVAILABLE" -eq 1 ]; then
        SCREENSHOT_ENGINE="gowitness"
        log_warn "pageres not available; falling back to GoWitness"
    else
        log_warn "Neither pageres nor GoWitness is available; skipping visual reconnaissance"
    fi
fi

# Show concise configuration summary
log_info "Configuration: Mode=${MODE} | Screenshot Engine=${SCREENSHOT_ENGINE} | Output=${OUT_DIR} | Screenshot Limit=${SCREENSHOT_COUNT_LIMIT:-auto} | Verbose=${VERBOSE}"

# ═══════════════════════════════════════════════════════════════════════════
#  PHASE 1: SUBDOMAIN ENUMERATION
# ═══════════════════════════════════════════════════════════════════════════

log_phase "PHASE 1: SUBDOMAIN ENUMERATION ${ICON_TARGET}"

log_progress "Running Subfinder (passive DNS)..."
touch "$OUT_DIR/raw/subfinder.txt"
if timeout 180 subfinder -d "$TARGET" -silent -o "$OUT_DIR/raw/subfinder.txt" 2>/dev/null && [ -s "$OUT_DIR/raw/subfinder.txt" ]; then
    SUBFINDER_COUNT=$(wc -l < "$OUT_DIR/raw/subfinder.txt" 2>/dev/null || echo 0)
    log_success "Subfinder: $SUBFINDER_COUNT subdomains discovered"
else
    SUBFINDER_COUNT=0
    log_warn "Subfinder execution failed or timed out (check internet connection)"
fi

log_progress "Running Assetfinder..."
touch "$OUT_DIR/raw/assetfinder.txt"
if timeout 120 assetfinder --subs-only "$TARGET" > "$OUT_DIR/raw/assetfinder.txt" 2>/dev/null && [ -s "$OUT_DIR/raw/assetfinder.txt" ]; then
    ASSET_COUNT=$(wc -l < "$OUT_DIR/raw/assetfinder.txt" 2>/dev/null || echo 0)
    log_success "Assetfinder: $ASSET_COUNT subdomains discovered"
else
    ASSET_COUNT=0
    log_warn "Assetfinder execution failed or timed out"
fi

if [ "$SKIP_CRTSH" = false ]; then
    log_progress "Querying Certificate Transparency logs (crt.sh)..."
    touch "$OUT_DIR/raw/crtsh.txt"
    if timeout 60 curl -s "https://crt.sh/?q=%25.$TARGET&output=json" | \
       jq -r '.[].name_value' 2>/dev/null | \
       sed 's/\*\.//g' | \
       sort -u > "$OUT_DIR/raw/crtsh.txt" && [ -s "$OUT_DIR/raw/crtsh.txt" ]; then
        CRT_COUNT=$(wc -l < "$OUT_DIR/raw/crtsh.txt" 2>/dev/null || echo 0)
        log_success "Certificate Transparency: $CRT_COUNT subdomains discovered"
    else
        CRT_COUNT=0
        log_warn "crt.sh query failed or timed out"
        touch "$OUT_DIR/raw/crtsh.txt"  # Ensure file exists
    fi
else
    CRT_COUNT=0
    touch "$OUT_DIR/raw/crtsh.txt"  # Create empty file
    log_info "Skipping crt.sh (fast mode)"
fi

if [ "$SKIP_WAYBACK" = false ]; then
    log_progress "Fetching historical data from Wayback Machine..."
    touch "$OUT_DIR/raw/wayback.txt"
    if timeout 120 bash -c "echo '$TARGET' | waybackurls 2>/dev/null | \
       grep -oP 'https?://\K[^/]+' | \
       sort -u > '$OUT_DIR/raw/wayback.txt'" && [ -s "$OUT_DIR/raw/wayback.txt" ]; then
        WAYBACK_COUNT=$(wc -l < "$OUT_DIR/raw/wayback.txt" 2>/dev/null || echo 0)
        log_success "Wayback Machine: $WAYBACK_COUNT unique hosts discovered"
    else
        WAYBACK_COUNT=0
        log_warn "Wayback Machine query failed or timed out"
        touch "$OUT_DIR/raw/wayback.txt"  # Ensure file exists
    fi
else
    WAYBACK_COUNT=0
    touch "$OUT_DIR/raw/wayback.txt"  # Create empty file
    log_info "Skipping Wayback Machine (fast mode)"
fi

log_progress "Consolidating and deduplicating results..."

# Ensure all files exist
touch "$OUT_DIR/raw/subfinder.txt" "$OUT_DIR/raw/assetfinder.txt" "$OUT_DIR/raw/crtsh.txt" "$OUT_DIR/raw/wayback.txt"

# Combine all results
cat "$OUT_DIR/raw/subfinder.txt" \
    "$OUT_DIR/raw/assetfinder.txt" \
    "$OUT_DIR/raw/crtsh.txt" \
    "$OUT_DIR/raw/wayback.txt" 2>/dev/null | \
    sort -u | \
    grep -F "$TARGET" | \
    grep -v '\*' > "$OUT_DIR/final/all_subdomains.txt" || true

SUB_COUNT=$(wc -l < "$OUT_DIR/final/all_subdomains.txt" 2>/dev/null || echo 0)

# Ensure we have at least something
if [ "$SUB_COUNT" -eq 0 ]; then
    log_error "No subdomains found. Check if tools are working properly."
fi

print_divider
echo -e "${BRIGHT_GREEN}    ${ICON_DATA} SUBDOMAIN ENUMERATION RESULTS:${NC}"
echo -e "${DIM}       ├─${NC} Subfinder         : ${BRIGHT_GREEN}$SUBFINDER_COUNT${NC}"
echo -e "${DIM}       ├─${NC} Assetfinder       : ${BRIGHT_GREEN}$ASSET_COUNT${NC}"
echo -e "${DIM}       ├─${NC} Certificate Trans.: ${BRIGHT_GREEN}$CRT_COUNT${NC}"
echo -e "${DIM}       ├─${NC} Wayback Machine   : ${BRIGHT_GREEN}$WAYBACK_COUNT${NC}"
echo -e "${DIM}       └─${NC} ${BRIGHT_RED}TOTAL TARGETS      : ${BOLD}$SUB_COUNT${NC}"
print_divider

# ═══════════════════════════════════════════════════════════════════════════
#  PHASE 2: LIVE HOST DETECTION
# ═══════════════════════════════════════════════════════════════════════════

log_phase "PHASE 2: LIVE HOST DETECTION ${ICON_SCAN}"

log_progress "Probing hosts with HTTPX (${HTTPX_THREADS} threads)..."
if httpx -l "$OUT_DIR/final/all_subdomains.txt" \
    -silent \
    -status-code \
    -title \
    -tech-detect \
    -follow-redirects \
    -threads "$HTTPX_THREADS" \
    -timeout "$HTTPX_TIMEOUT" \
    -retries 1 \
    -o "$OUT_DIR/final/httpx_details.txt" 2>/dev/null; then

    # Extract live hosts
    awk '{print $1}' "$OUT_DIR/final/httpx_details.txt" | sort -u > "$OUT_DIR/final/live_hosts.txt"
    LIVE_COUNT=$(wc -l < "$OUT_DIR/final/live_hosts.txt")

    # Count by status code
    STATUS_200=$(grep -c '\[200\]' "$OUT_DIR/final/httpx_details.txt" 2>/dev/null || echo 0)
    STATUS_301=$(grep -c '\[301\]' "$OUT_DIR/final/httpx_details.txt" 2>/dev/null || echo 0)
    STATUS_302=$(grep -c '\[302\]' "$OUT_DIR/final/httpx_details.txt" 2>/dev/null || echo 0)
    STATUS_403=$(grep -c '\[403\]' "$OUT_DIR/final/httpx_details.txt" 2>/dev/null || echo 0)

    print_divider
    echo -e "${BRIGHT_GREEN}    ${ICON_SCAN} LIVE HOST DETECTION RESULTS:${NC}"
    echo -e "${DIM}       ├─${NC} Total Live Hosts  : ${BRIGHT_RED}${BOLD}$LIVE_COUNT${NC} ${DIM}/ $SUB_COUNT${NC}"
    echo -e "${DIM}       ├─${NC} 200 OK            : ${BRIGHT_GREEN}$STATUS_200${NC}"
    echo -e "${DIM}       ├─${NC} 301 Redirect      : ${WHITE}$STATUS_301${NC}"
    echo -e "${DIM}       ├─${NC} 302 Redirect      : ${WHITE}$STATUS_302${NC}"
    echo -e "${DIM}       └─${NC} 403 Forbidden     : ${BRIGHT_RED}$STATUS_403${NC}"
    print_divider

    log_success "Live host detection complete"
else
    log_warn "HTTPX probe failed"
    LIVE_COUNT=0
fi

# ═══════════════════════════════════════════════════════════════════════════
#  PHASE 3: VULNERABILITY SCANNING
# ═══════════════════════════════════════════════════════════════════════════

log_phase "PHASE 3: VULNERABILITY ASSESSMENT ${ICON_EXPLOIT}"

if [ "$LIVE_COUNT" -gt 0 ]; then
    # Limit hosts to scan in fast/balanced mode
    NUCLEI_INPUT="$OUT_DIR/final/live_hosts.txt"
    HOSTS_TO_SCAN=$LIVE_COUNT

    if [ "$NUCLEI_HOST_LIMIT" -gt 0 ] && [ "$LIVE_COUNT" -gt "$NUCLEI_HOST_LIMIT" ]; then
        log_info "Limiting scan to top $NUCLEI_HOST_LIMIT hosts (out of $LIVE_COUNT total)"
        # Prioritize 200 OK hosts
        grep '\[200\]' "$OUT_DIR/final/httpx_details.txt" 2>/dev/null | \
            awk '{print $1}' | \
            head -"$NUCLEI_HOST_LIMIT" > "$OUT_DIR/raw/nuclei_targets.txt"

        # If not enough 200s, fill with other hosts
        CURRENT_COUNT=$(wc -l < "$OUT_DIR/raw/nuclei_targets.txt" 2>/dev/null || echo 0)
        if [ "$CURRENT_COUNT" -lt "$NUCLEI_HOST_LIMIT" ]; then
            REMAINING=$((NUCLEI_HOST_LIMIT - CURRENT_COUNT))
            head -"$NUCLEI_HOST_LIMIT" "$OUT_DIR/final/live_hosts.txt" > "$OUT_DIR/raw/nuclei_targets.txt"
        fi

        NUCLEI_INPUT="$OUT_DIR/raw/nuclei_targets.txt"
        HOSTS_TO_SCAN=$(wc -l < "$NUCLEI_INPUT")
    fi

    # Helper: run nuclei with optional host-splitting for parallelism
    run_nuclei() {
        local input="$1"
        local out="$2"
        local severity="$3"
        local concurrency="$4"
        local timeout="$5"
        local rl="${6:-$NUCLEI_RATE_LIMIT}"
        local parallel="${7:-$NUCLEI_PARALLEL}"

        mkdir -p "$(dirname "$out")" 2>/dev/null || true

        if [ "$parallel" -gt 1 ] && command -v split >/dev/null 2>&1; then
            # split into roughly equal parts
            rm -f "$OUT_DIR/raw/nuclei_chunk_"* >/dev/null 2>&1 || true
            split -n l/$parallel "$input" "$OUT_DIR/raw/nuclei_chunk_" || true
            # run nuclei in parallel and collect outputs
            for f in "$OUT_DIR"/raw/nuclei_chunk_*; do
                [ -s "$f" ] || continue
                nuclei -l "$f" -severity "$severity" -rl "$rl" -c "$concurrency" -timeout "$timeout" -retries 1 -o "${f}.out" -silent >/dev/null 2>&1 || true &
            done
            wait || true
            : > "$out"
            for f in "$OUT_DIR"/raw/nuclei_chunk_*.out; do
                [ -f "$f" ] && cat "$f" >> "$out"
            done
            # cleanup chunks
            rm -f "$OUT_DIR"/raw/nuclei_chunk_* >/dev/null 2>&1 || true
        else
            nuclei -l "$input" -severity "$severity" -rl "$rl" -c "$concurrency" -timeout "$timeout" -retries 1 -o "$out" -silent >/dev/null 2>&1 || true
        fi
    }

    log_progress "Running Nuclei scanner on $HOSTS_TO_SCAN hosts (severity: medium+)..."

    # Update templates only in deep mode
    if [ "$MODE" = "deep" ]; then
        nuclei -update-templates >/dev/null 2>&1 || log_warn "Could not update Nuclei templates"
    fi

    # Two-pass strategy: quick pass in fast/balanced, deep or full in deep
    if [ -n "${NUCLEI_QUICK_SEVERITY:-}" ] && { [ "$MODE" = "fast" ] || [ "$MODE" = "balanced" ]; }; then
        log_progress "Nuclei quick pass (severity: $NUCLEI_QUICK_SEVERITY)"
        run_nuclei "$NUCLEI_INPUT" "$OUT_DIR/final/nuclei_quick.txt" "$NUCLEI_QUICK_SEVERITY" "${NUCLEI_QUICK_CONCURRENCY:-$NUCLEI_CONCURRENCY}" "${NUCLEI_QUICK_TIMEOUT:-$NUCLEI_TIMEOUT}"

        QUICK_COUNT=$(wc -l < "$OUT_DIR/final/nuclei_quick.txt" 2>/dev/null || echo 0)
        log_info "Quick pass findings: $QUICK_COUNT"

        if [ "$QUICK_COUNT" -gt 0 ]; then
            # Run targeted deep scan on hosts with quick findings
            awk '{print $1}' "$OUT_DIR/final/nuclei_quick.txt" | sed 's/:.*//' | sort -u > "$OUT_DIR/raw/nuclei_quick_hosts.txt"
            TARGET_COUNT=$(wc -l < "$OUT_DIR/raw/nuclei_quick_hosts.txt" 2>/dev/null || echo 0)
            log_progress "Targeted deep scan on $TARGET_COUNT hosts with quick findings"
            run_nuclei "$OUT_DIR/raw/nuclei_quick_hosts.txt" "$OUT_DIR/final/nuclei_hits.txt" "medium,high,critical" "$NUCLEI_CONCURRENCY" "$NUCLEI_TIMEOUT"
        else
            # No quick findings - keep an empty result file
            : > "$OUT_DIR/final/nuclei_hits.txt"
        fi
    else
        # Full scan for deep mode or balanced when quick not configured
        run_nuclei "$NUCLEI_INPUT" "$OUT_DIR/final/nuclei_hits.txt" "medium,high,critical" "$NUCLEI_CONCURRENCY" "$NUCLEI_TIMEOUT"
    fi

    # Post-process results
    if [ -s "$OUT_DIR/final/nuclei_hits.txt" ]; then
        NUCLEI_COUNT=$(wc -l < "$OUT_DIR/final/nuclei_hits.txt" 2>/dev/null || echo 0)

        if [ "$NUCLEI_COUNT" -gt 0 ]; then
            # Count by severity
            CRITICAL=$(grep -ci 'critical' "$OUT_DIR/final/nuclei_hits.txt" 2>/dev/null || echo 0)
            HIGH=$(grep -ci 'high' "$OUT_DIR/final/nuclei_hits.txt" 2>/dev/null || echo 0)
            MEDIUM=$(grep -ci 'medium' "$OUT_DIR/final/nuclei_hits.txt" 2>/dev/null || echo 0)
            LOW=$(grep -ci 'low' "$OUT_DIR/final/nuclei_hits.txt" 2>/dev/null || echo 0)

            print_divider
            echo -e "${BRIGHT_RED}    ${ICON_EXPLOIT} VULNERABILITY SCAN RESULTS:${NC}"
            [ "$CRITICAL" -gt 0 ] && echo -e "${DIM}       ├─${NC} ${BRIGHT_RED}${BOLD}${BLINK}CRITICAL${NC}       : ${BRIGHT_RED}${BOLD}$CRITICAL${NC}"
            [ "$HIGH" -gt 0 ] && echo -e "${DIM}       ├─${NC} ${BRIGHT_RED}HIGH${NC}          : ${BRIGHT_RED}$HIGH${NC}"
            [ "$MEDIUM" -gt 0 ] && echo -e "${DIM}       ├─${NC} ${YELLOW}MEDIUM${NC}        : ${YELLOW}$MEDIUM${NC}"
            [ "$LOW" -gt 0 ] && echo -e "${DIM}       ├─${NC} ${BRIGHT_GREEN}LOW${NC}           : ${BRIGHT_GREEN}$LOW${NC}"
            echo -e "${DIM}       └─${NC} Total Findings: ${BRIGHT_RED}${BOLD}$NUCLEI_COUNT${NC}"
            print_divider

            log_success "Nuclei scan completed - vulnerabilities detected!"
        else
            log_info "Nuclei scan completed - no vulnerabilities detected"
        fi
    else
        touch "$OUT_DIR/final/nuclei_hits.txt"
        log_info "Nuclei scan completed - no vulnerabilities detected"
        NUCLEI_COUNT=0
    fi
else
    log_warn "No live hosts to scan - skipping Nuclei"
    NUCLEI_COUNT=0
fi

# ═══════════════════════════════════════════════════════════════════════════
#  PHASE 4: VISUAL RECONNAISSANCE
# ═══════════════════════════════════════════════════════════════════════════

log_phase "PHASE 4: VISUAL RECONNAISSANCE ${ICON_TARGET}"

if [ "$LIVE_COUNT" -gt 0 ]; then
    # Get top N live hosts (prioritize 200 OK responses)
    log_progress "Selecting top $SCREENSHOT_COUNT_LIMIT hosts for screenshots..."

    # Guard against missing or empty httpx output to avoid failing under "set -o pipefail"
    if [ -s "$OUT_DIR/final/httpx_details.txt" ]; then
        grep '\[200\]' "$OUT_DIR/final/httpx_details.txt" 2>/dev/null | \
            awk '{print $1}' | \
            head -n "$SCREENSHOT_COUNT_LIMIT" > "$OUT_DIR/raw/top_hosts.txt" || true
    else
        # No httpx details available; start with an empty top_hosts list and warn
        log_warn "httpx details not found — falling back to live hosts (if available)"
        : > "$OUT_DIR/raw/top_hosts.txt"
    fi

    # If we don't have enough, fill with other status codes or fall back to live hosts
    if [ "$(wc -l < "$OUT_DIR/raw/top_hosts.txt" 2>/dev/null || echo 0)" -lt "$SCREENSHOT_COUNT_LIMIT" ]; then
        if [ -s "$OUT_DIR/final/live_hosts.txt" ]; then
            head -n "$SCREENSHOT_COUNT_LIMIT" "$OUT_DIR/final/live_hosts.txt" > "$OUT_DIR/raw/top_hosts.txt"
        else
            log_warn "No live hosts available to select for screenshots"
            : > "$OUT_DIR/raw/top_hosts.txt"
        fi
    fi

    TOP_COUNT=$(wc -l < "$OUT_DIR/raw/top_hosts.txt" 2>/dev/null || echo 0)
    log_info "Selected $TOP_COUNT hosts for visual capture"

    case "$SCREENSHOT_ENGINE" in
        "none")
            log_warn "Skipping visual reconnaissance (no screenshot engine available)"
            SCREENSHOT_COUNT=0
            ;;

        "gowitness")
            log_progress "Capturing screenshots with GoWitness..."

            # Prefer modern `gowitness scan file` syntax when available
            if gowitness scan file -f "$OUT_DIR/raw/top_hosts.txt" --screenshot-path "$OUT_DIR/screenshots" \
                --chrome-path /usr/bin/google-chrome --chrome-window-x 1280 --chrome-window-y 720 \
                --delay 1 --timeout 10 >/dev/null 2>&1; then

                GW_OK=1
            elif gowitness file -f "$OUT_DIR/raw/top_hosts.txt" -P "$OUT_DIR/screenshots" --disable-db --timeout 10 >/dev/null 2>&1; then
                # legacy syntax
                GW_OK=1
            else
                GW_OK=0
            fi

            if [ "$GW_OK" -eq 1 ]; then
                SCREENSHOT_COUNT=$(find "$OUT_DIR/screenshots" -name "*.png" 2>/dev/null | wc -l)
                if [ "$SCREENSHOT_COUNT" -gt 0 ]; then
                    log_success "Screenshots captured: $SCREENSHOT_COUNT / $TOP_COUNT"
                else
                    log_warn "GoWitness ran but no screenshots were saved"
                    SCREENSHOT_COUNT=0
                fi
            else
                log_warn "GoWitness failed to capture screenshots"
                SCREENSHOT_COUNT=0

                # Auto-fallback to pageres if available
                if [ "$PAGERES_AVAILABLE" -eq 1 ]; then
                    log_progress "Attempting screenshot capture with pageres (fallback)..."
                    mkdir -p "$OUT_DIR/screenshots"

                    while IFS= read -r url; do
                        [ -z "$url" ] && continue
                        if ! echo "$url" | grep -qE '^[a-zA-Z]+://'; then
                            url="http://$url"
                        fi
                        filename=$(echo "$url" | sed -E 's#https?://##; s#/##g; s/[:?=&]\/_/-/_/g' | sed 's/[^A-Za-z0-9._-]/_/g')
                        pageres "$url" 1280x720 --filename="$filename" --dest="$OUT_DIR/screenshots" >/dev/null 2>&1 || log_warn "pageres failed for $url"
                    done < "$OUT_DIR/raw/top_hosts.txt"

                    SCREENSHOT_COUNT=$(find "$OUT_DIR/screenshots" -name "*.png" 2>/dev/null | wc -l)
                    if [ "$SCREENSHOT_COUNT" -gt 0 ]; then
                        log_success "Screenshots captured with pageres: $SCREENSHOT_COUNT / $TOP_COUNT"
                    else
                        log_warn "pageres ran but no screenshots were saved"
                        SCREENSHOT_COUNT=0
                    fi
                else
                    log_warn "pageres not available for fallback; no screenshots were captured"
                fi
            fi
            ;;

        "pageres")
            log_progress "Capturing screenshots with pageres..."
            mkdir -p "$OUT_DIR/screenshots"
            if [ -s "$OUT_DIR/raw/top_hosts.txt" ]; then
                while IFS= read -r url; do
                    [ -z "$url" ] && continue
                    if ! echo "$url" | grep -qE '^[a-zA-Z]+://'; then
                        url="http://$url"
                    fi
                    filename=$(echo "$url" | sed -E 's#https?://##; s#/##g; s/[:?=&]\/_/-/_/g' | sed 's/[^A-Za-z0-9._-]/_/g')
                    pageres "$url" 1280x720 --filename="$filename" --dest="$OUT_DIR/screenshots" >/dev/null 2>&1 || log_warn "pageres failed for $url"
                done < "$OUT_DIR/raw/top_hosts.txt"

                SCREENSHOT_COUNT=$(find "$OUT_DIR/screenshots" -name "*.png" 2>/dev/null | wc -l)
                if [ "$SCREENSHOT_COUNT" -gt 0 ]; then
                    log_success "Screenshots captured with pageres: $SCREENSHOT_COUNT / $TOP_COUNT"
                else
                    log_warn "pageres ran but no screenshots were saved"
                    SCREENSHOT_COUNT=0
                fi
            else
                log_warn "No hosts available for pageres"; SCREENSHOT_COUNT=0
            fi
            ;;
    esac
else
    log_warn "No live hosts to screenshot"
    SCREENSHOT_COUNT=0
fi

# ═══════════════════════════════════════════════════════════════════════════
#  GENERATE HTML DASHBOARD
# ═══════════════════════════════════════════════════════════════════════════

generate_dashboard() {
    log_info "Generating interactive HTML dashboard..."

    local DASHBOARD="$OUT_DIR/dashboard.html"

    cat > "$DASHBOARD" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RECON_TITLE - Bug Bounty Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Courier New', 'Consolas', monospace;
            background: #0a0a0a;
            color: #00ff00;
            padding: 20px;
            line-height: 1.6;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            background: linear-gradient(135deg, #000000 0%, #1a1a1a 100%);
            border: 2px solid #00ff00;
            padding: 30px;
            border-radius: 0;
            margin-bottom: 30px;
            box-shadow: 0 0 20px rgba(0, 255, 0, 0.3);
            position: relative;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg,
                transparent,
                #00ff00,
                transparent
            );
            animation: scan 2s linear infinite;
        }

        @keyframes scan {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }

        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            color: #ff0000;
            text-shadow: 0 0 10px #ff0000, 0 0 20px #ff0000;
            font-weight: bold;
        }

        .header .meta {
            color: #00ff00;
            font-size: 0.95em;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: #000000;
            border: 2px solid #00ff00;
            padding: 25px;
            border-radius: 0;
            transition: all 0.3s ease;
            box-shadow: 0 0 15px rgba(0, 255, 0, 0.2);
        }

        .stat-card:hover {
            border-color: #ff0000;
            box-shadow: 0 0 25px rgba(255, 0, 0, 0.5);
            transform: translateY(-5px);
        }

        .stat-card .icon {
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        .stat-card .label {
            font-size: 0.9em;
            color: #00ff00;
            margin-bottom: 5px;
        }

        .stat-card .value {
            font-size: 2.5em;
            font-weight: bold;
            color: #ff0000;
            text-shadow: 0 0 10px #ff0000;
        }

        .section {
            background: #000000;
            border: 2px solid #00ff00;
            padding: 30px;
            border-radius: 0;
            margin-bottom: 30px;
            box-shadow: 0 0 15px rgba(0, 255, 0, 0.2);
        }

        .section h2 {
            font-size: 1.8em;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #00ff00;
            color: #ff0000;
            text-shadow: 0 0 10px #ff0000;
        }

        .screenshots-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .screenshot-card {
            background: #0a0a0a;
            border: 1px solid #00ff00;
            border-radius: 0;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .screenshot-card:hover {
            border-color: #ff0000;
            box-shadow: 0 0 20px rgba(255, 0, 0, 0.5);
            transform: scale(1.03);
        }

        .screenshot-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            cursor: pointer;
            filter: brightness(0.8) contrast(1.2);
        }

        .screenshot-card .info {
            padding: 15px;
        }

        .screenshot-card .url {
            font-size: 0.9em;
            word-break: break-all;
            color: #00ff00;
        }

        .vuln-list {
            max-height: 500px;
            overflow-y: auto;
        }

        .vuln-item {
            background: #0a0a0a;
            padding: 15px;
            border-radius: 0;
            margin-bottom: 10px;
            border-left: 4px solid;
            font-family: 'Courier New', monospace;
        }

        .vuln-item.critical {
            border-color: #ff0000;
            background: rgba(255, 0, 0, 0.1);
        }
        .vuln-item.high {
            border-color: #ff6b6b;
            background: rgba(255, 107, 107, 0.1);
        }
        .vuln-item.medium {
            border-color: #ffa500;
            background: rgba(255, 165, 0, 0.1);
        }
        .vuln-item.low {
            border-color: #00ff00;
            background: rgba(0, 255, 0, 0.1);
        }

        .vuln-item .severity {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 0;
            font-size: 0.85em;
            font-weight: bold;
            margin-bottom: 8px;
            border: 1px solid;
        }

        .severity.critical {
            background: #ff0000;
            color: #000;
            border-color: #ff0000;
            animation: blink 1s infinite;
        }

        @keyframes blink {
            0%, 50%, 100% { opacity: 1; }
            25%, 75% { opacity: 0.5; }
        }

        .severity.high {
            background: #ff6b6b;
            color: #000;
            border-color: #ff6b6b;
        }
        .severity.medium {
            background: #ffa500;
            color: #000;
            border-color: #ffa500;
        }
        .severity.low {
            background: #00ff00;
            color: #000;
            border-color: #00ff00;
        }

        .host-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 15px;
            max-height: 400px;
            overflow-y: auto;
        }

        .host-item {
            background: #0a0a0a;
            padding: 12px 15px;
            border-radius: 0;
            border: 1px solid #00ff00;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            transition: all 0.3s ease;
        }

        .host-item:hover {
            background: #1a1a1a;
            border-color: #ff0000;
            box-shadow: 0 0 10px rgba(255, 0, 0, 0.3);
        }

        .host-item a {
            color: #00ff00;
            text-decoration: none;
        }

        .host-item a:hover {
            color: #ff0000;
            text-shadow: 0 0 5px #ff0000;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #00ff00;
            font-size: 1.1em;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.95);
            justify-content: center;
            align-items: center;
        }

        .modal img {
            max-width: 90%;
            max-height: 90%;
            border: 2px solid #00ff00;
            box-shadow: 0 0 30px rgba(0, 255, 0, 0.5);
        }

        .modal-close {
            position: absolute;
            top: 30px;
            right: 50px;
            font-size: 40px;
            color: #ff0000;
            cursor: pointer;
            transition: all 0.3s;
            text-shadow: 0 0 10px #ff0000;
        }

        .modal-close:hover {
            transform: scale(1.2);
            text-shadow: 0 0 20px #ff0000;
        }

        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .tab {
            padding: 12px 24px;
            background: #000000;
            border: 2px solid #00ff00;
            border-radius: 0;
            color: #00ff00;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.95em;
            font-family: 'Courier New', monospace;
        }

        .tab:hover {
            background: #00ff00;
            color: #000000;
            box-shadow: 0 0 15px rgba(0, 255, 0, 0.5);
        }

        .tab.active {
            background: #ff0000;
            border-color: #ff0000;
            color: #000000;
            font-weight: bold;
            box-shadow: 0 0 20px rgba(255, 0, 0, 0.5);
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        ::-webkit-scrollbar {
            width: 10px;
        }

        ::-webkit-scrollbar-track {
            background: #000000;
            border: 1px solid #00ff00;
        }

        ::-webkit-scrollbar-thumb {
            background: #00ff00;
            border: 1px solid #00ff00;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #ff0000;
            border-color: #ff0000;
        }

        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .screenshots-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>☠ BUG BOUNTY RECON REPORT ☠</h1>
            <div class="meta">
                <strong style="color: #ff0000;">TARGET:</strong> <span style="color: #00ff00;">RECON_TITLE</span><br>
                <strong style="color: #ff0000;">SCAN DATE:</strong> <span style="color: #00ff00;">RECON_DATE</span><br>
                <strong style="color: #ff0000;">DURATION:</strong> <span style="color: #00ff00;">RECON_DURATION seconds</span><br>
                <strong style="color: #ff0000;">OPERATOR:</strong> <span style="color: #00ff00;">Mr.Beka</span>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="icon">🌐</div>
                <div class="label">Subdomains Found</div>
                <div class="value">STAT_SUBDOMAINS</div>
            </div>
            <div class="stat-card">
                <div class="icon">✅</div>
                <div class="label">Live Hosts</div>
                <div class="value">STAT_LIVE</div>
            </div>
            <div class="stat-card">
                <div class="icon">🔒</div>
                <div class="label">Vulnerabilities</div>
                <div class="value">STAT_VULNS</div>
            </div>
            <div class="stat-card">
                <div class="icon">📸</div>
                <div class="label">Screenshots</div>
                <div class="value">STAT_SCREENSHOTS</div>
            </div>
        </div>

        <div class="section">
            <h2>🔍 Navigation</h2>
            <div class="tabs">
                <button class="tab active" onclick="showTab('screenshots')">📸 Screenshots</button>
                <button class="tab" onclick="showTab('vulnerabilities')">🔒 Vulnerabilities</button>
                <button class="tab" onclick="showTab('hosts')">🌐 Live Hosts</button>
                <button class="tab" onclick="showTab('subdomains')">📋 All Subdomains</button>
            </div>

            <div id="screenshots" class="tab-content active">
                <h3 style="margin-bottom: 15px;">📸 Visual Reconnaissance (Top SCREENSHOT_LIMIT_DISPLAY Hosts)</h3>
                SCREENSHOTS_CONTENT
            </div>

            <div id="vulnerabilities" class="tab-content">
                <h3 style="margin-bottom: 15px;">🔒 Security Findings</h3>
                VULNERABILITIES_CONTENT
            </div>

            <div id="hosts" class="tab-content">
                <h3 style="margin-bottom: 15px;">🌐 Live Hosts (STAT_LIVE total)</h3>
                HOSTS_CONTENT
            </div>

            <div id="subdomains" class="tab-content">
                <h3 style="margin-bottom: 15px;">📋 All Discovered Subdomains (STAT_SUBDOMAINS total)</h3>
                SUBDOMAINS_CONTENT
            </div>
        </div>
    </div>

    <div id="imageModal" class="modal" onclick="closeModal()">
        <span class="modal-close">&times;</span>
        <img id="modalImage" src="" alt="Screenshot">
    </div>

    <script>
        function showTab(tabName) {
            const tabs = document.querySelectorAll('.tab');
            const contents = document.querySelectorAll('.tab-content');

            tabs.forEach(tab => tab.classList.remove('active'));
            contents.forEach(content => content.classList.remove('active'));

            event.target.classList.add('active');
            document.getElementById(tabName).classList.add('active');
        }

        function openModal(imgSrc) {
            document.getElementById('imageModal').style.display = 'flex';
            document.getElementById('modalImage').src = imgSrc;
        }

        function closeModal() {
            document.getElementById('imageModal').style.display = 'none';
        }

        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') closeModal();
        });
    </script>
</body>
</html>
EOF

    # Generate screenshots section
    local SCREENSHOTS_HTML=""
    if [ "$SCREENSHOT_COUNT" -gt 0 ]; then
        SCREENSHOTS_HTML='<div class="screenshots-grid">'
        for img in "$OUT_DIR/screenshots"/*.png; do
            if [ -f "$img" ]; then
                local filename=$(basename "$img")
                local url=$(echo "$filename" | sed 's/^https-/https:\/\//' | sed 's/-/./g' | sed 's/\.png$//')
                SCREENSHOTS_HTML+="
                <div class='screenshot-card'>
                    <img src='screenshots/$filename' onclick=\"openModal('screenshots/$filename')\" alt='$url'>
                    <div class='info'>
                        <div class='url'>$url</div>
                    </div>
                </div>"
            fi
        done
        SCREENSHOTS_HTML+='</div>'
    else
        SCREENSHOTS_HTML="<div class='no-data'>📭 No screenshots captured</div>"
    fi

    # Generate vulnerabilities section
    local VULNS_HTML=""
    if [ "$NUCLEI_COUNT" -gt 0 ]; then
        VULNS_HTML='<div class="vuln-list">'
        while IFS= read -r line; do
            local severity=$(echo "$line" | grep -oP '\[(critical|high|medium|low)\]' | tr -d '[]' || echo "info")
            VULNS_HTML+="<div class='vuln-item $severity'><span class='severity $severity'>$severity</span><br>$line</div>"
        done < "$OUT_DIR/final/nuclei_hits.txt"
        VULNS_HTML+='</div>'
    else
        VULNS_HTML="<div class='no-data'>🛡️ No vulnerabilities detected - Good job securing these assets!</div>"
    fi

    # Generate live hosts section
    local HOSTS_HTML='<div class="host-list">'
    while IFS= read -r host; do
        HOSTS_HTML+="<div class='host-item'><a href='$host' target='_blank'>$host</a></div>"
    done < "$OUT_DIR/final/live_hosts.txt"
    HOSTS_HTML+='</div>'

    # Generate subdomains section
    local SUBS_HTML='<div class="host-list">'
    while IFS= read -r sub; do
        SUBS_HTML+="<div class='host-item'>$sub</div>"
    done < "$OUT_DIR/final/all_subdomains.txt"
    SUBS_HTML+='</div>'

    # Replace placeholders
    sed -i "s|RECON_TITLE|$TARGET|g" "$DASHBOARD"
    sed -i "s|RECON_DATE|$(date +'%Y-%m-%d %H:%M:%S')|g" "$DASHBOARD"
    sed -i "s|RECON_DURATION|$DURATION|g" "$DASHBOARD"
    sed -i "s|STAT_SUBDOMAINS|$SUB_COUNT|g" "$DASHBOARD"
    sed -i "s|STAT_LIVE|$LIVE_COUNT|g" "$DASHBOARD"
    sed -i "s|STAT_VULNS|$NUCLEI_COUNT|g" "$DASHBOARD"
    sed -i "s|STAT_SCREENSHOTS|$SCREENSHOT_COUNT|g" "$DASHBOARD"
    sed -i "s|SCREENSHOT_LIMIT_DISPLAY|$SCREENSHOT_COUNT_LIMIT|g" "$DASHBOARD"
    sed -i "s|SCREENSHOTS_CONTENT|$SCREENSHOTS_HTML|g" "$DASHBOARD"
    sed -i "s|VULNERABILITIES_CONTENT|$VULNS_HTML|g" "$DASHBOARD"
    sed -i "s|HOSTS_CONTENT|$HOSTS_HTML|g" "$DASHBOARD"
    sed -i "s|SUBDOMAINS_CONTENT|$SUBS_HTML|g" "$DASHBOARD"

    log_success "Dashboard generated: $DASHBOARD"
}

# ═══════════════════════════════════════════════════════════════════════════
#  FINAL SUMMARY & REPORT
# ═══════════════════════════════════════════════════════════════════════════

END_TIME=$(date +'%Y-%m-%d %H:%M:%S')
DURATION=$(($(date +%s) - $(date -d "$(head -1 "$LOG_FILE" | grep -oP '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}')" +%s 2>/dev/null || echo 0)))

# Generate the interactive dashboard
generate_dashboard

echo ""
echo -e "${BRIGHT_RED}${BOLD}    ╔══════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BRIGHT_RED}${BOLD}    ║${NC}              ${BRIGHT_GREEN}${BOLD}${ICON_HACK} RECONNAISSANCE COMPLETE ${ICON_HACK}${NC}                     ${BRIGHT_RED}${BOLD}║${NC}"
echo -e "${BRIGHT_RED}${BOLD}    ╚══════════════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BRIGHT_GREEN}    ${ICON_DATA} MISSION SUMMARY:${NC}"
echo -e "${BRIGHT_RED}    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${NC}"
echo -e "${BRIGHT_RED}    ┃${NC} ${BRIGHT_GREEN}Target Domain      :${NC} ${BRIGHT_RED}$TARGET${NC}"
echo -e "${BRIGHT_RED}    ┃${NC} ${BRIGHT_GREEN}Scan Completed     :${NC} ${WHITE}$END_TIME${NC}"
echo -e "${BRIGHT_RED}    ┃${NC} ${BRIGHT_GREEN}Duration           :${NC} ${WHITE}${DURATION}s${NC}"
echo -e "${BRIGHT_RED}    ┃${NC} ${BRIGHT_GREEN}Scan Mode          :${NC} ${BRIGHT_RED}${MODE^^}${NC}"
echo -e "${BRIGHT_RED}    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫${NC}"
echo -e "${BRIGHT_RED}    ┃${NC} ${BRIGHT_GREEN}${BOLD}Subdomains Found   :${NC} ${BRIGHT_RED}${BOLD}$SUB_COUNT${NC}"
echo -e "${BRIGHT_RED}    ┃${NC} ${BRIGHT_GREEN}${BOLD}Live Hosts         :${NC} ${BRIGHT_RED}${BOLD}$LIVE_COUNT${NC}"
echo -e "${BRIGHT_RED}    ┃${NC} ${BRIGHT_GREEN}${BOLD}Vulnerabilities    :${NC} ${BRIGHT_RED}${BOLD}$NUCLEI_COUNT${NC}"
echo -e "${BRIGHT_RED}    ┃${NC} ${BRIGHT_GREEN}${BOLD}Screenshots        :${NC} ${BRIGHT_RED}${BOLD}$SCREENSHOT_COUNT${NC}"
echo -e "${BRIGHT_RED}    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫${NC}"
echo -e "${BRIGHT_RED}    ┃${NC} ${BRIGHT_GREEN}Output Directory   :${NC}"
echo -e "${BRIGHT_RED}    ┃${NC} ${DIM}$OUT_DIR${NC}"
echo -e "${BRIGHT_RED}    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
echo ""

# Generate quick access paths
echo -e "${BRIGHT_GREEN}    ${ICON_LOCK} LOOT COLLECTED:${NC}"
echo -e "${DIM}       ├─${NC} ${BRIGHT_RED}${BOLD}Interactive Dashboard${NC} : ${BRIGHT_GREEN}$OUT_DIR/dashboard.html${NC}"
echo -e "${DIM}       ├─${NC} All Subdomains : ${DIM}$OUT_DIR/final/all_subdomains.txt${NC}"
echo -e "${DIM}       ├─${NC} Live Hosts     : ${DIM}$OUT_DIR/final/live_hosts.txt${NC}"
echo -e "${DIM}       ├─${NC} HTTPX Details  : ${DIM}$OUT_DIR/final/httpx_details.txt${NC}"
[ "$NUCLEI_COUNT" -gt 0 ] && echo -e "${DIM}       ├─${NC} ${BRIGHT_RED}Nuclei Findings: ${BRIGHT_GREEN}$OUT_DIR/final/nuclei_hits.txt${NC}"
[ "$SCREENSHOT_COUNT" -gt 0 ] && echo -e "${DIM}       ├─${NC} Screenshots    : ${DIM}$OUT_DIR/screenshots/${NC}"
echo -e "${DIM}       └─${NC} Full Log       : ${DIM}$LOG_FILE${NC}"
echo ""

log_success "Mission accomplished! Target neutralized. ${ICON_HACK}"
echo ""
echo -e "${BRIGHT_GREEN}    ${ICON_TARGET} VIEW RESULTS:${NC} ${BRIGHT_RED}firefox $OUT_DIR/dashboard.html${NC}"
echo -e "${DIM}                      or: google-chrome $OUT_DIR/dashboard.html${NC}"
echo ""
echo -e "${BRIGHT_GREEN}${BOLD}    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BRIGHT_GREEN}${BOLD}                    Coded with ${BRIGHT_RED}♥${BRIGHT_GREEN} by Mr.Beka                      ${NC}"
echo -e "${BRIGHT_GREEN}${BOLD}    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
