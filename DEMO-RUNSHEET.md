# Demo Session Run Sheet — DevOps on AWS (60 min)

**Goal of the demo:** the student sees *code → pipeline → live on AWS* in one hour, understands the 9-week path, and leaves wanting to enrol. You are selling the outcome, not teaching everything.

---

## Before the call (do this 1–2 hours earlier)

- [ ] Create a GitHub repo (e.g. `devops-demo`) and push this kit (`app/`, `.github/`, `terraform/`, `python/`)
- [ ] `cd terraform && terraform init && terraform apply -var="bucket_name=devops-demo-<you>-2026" -var="github_repo=<you>/devops-demo"`
- [ ] In GitHub repo → Settings → Secrets and variables → Actions → **Variables**: add `AWS_ROLE_ARN` and `BUCKET_NAME` from the Terraform outputs
- [ ] Push once, confirm the pipeline goes green and the website URL loads **v1**
- [ ] Run `terraform destroy` **only on the website bucket resources if you want to re-create live** — otherwise keep it applied and just show `plan`
- [ ] Open tabs: AWS console (S3, EC2), GitHub repo + Actions tab, VS Code with the kit, the website URL
- [ ] Have the program doc / WhatsApp summary ready to share at the end

> Never do the first-ever run live. Everything shown live must have worked once already.

---

## Session flow

| Time | Segment | What you do / say |
|---|---|---|
| 0–5 min | **Intro** | Who you are: DevOps engineer, working on a data platform at a London-based company, freelancing in AWS DevOps since 2022. Ask *them*: background, goal (job switch? upskill?), comfort with Linux/coding. **Note their answers — they shape your pitch at the end.** |
| 5–12 min | **What DevOps really is** | Draw the flow: *Developer writes code → Git → CI/CD pipeline → Cloud (AWS) → Monitoring → back to developer*. Explain the problem it solves: "manual deployments break things and are slow." Roles: DevOps, Cloud, SRE, Platform Engineer. |
| 12–20 min | **Live 1: AWS + Terraform** | Show S3 bucket in console. Then show `main.tf`: "this file *is* the infrastructure." Run `terraform plan` live. Key line: *"Companies don't click in the console — they write code like this."* |
| 20–35 min | **Live 2: The pipeline (the wow moment)** | Open `index.html`, change `v1` → `v2` (or the student's name). `git commit` + `git push`. Switch to GitHub Actions — walk through each step as it runs: checkout → **secrets scan** → **AWS login with no stored keys** → deploy. Refresh the website: v2 is live. *"That's what DevOps engineers build. You'll build this in Week 6."* |
| 35–42 min | **Live 3: Python automation** | Run `python cost_check.py`. Show it finding untagged instances / unused volumes. Message: *"Python in DevOps = automation and saving money, not web development."* (FinOps — a 2026 hiring keyword.) |
| 42–48 min | **What's current in DevOps** | 2 minutes each, verbally: GitOps (Argo CD), DevSecOps (the scan you just saw), AI coding agents (show Claude Code/Copilot writing a Terraform block, then *you* review it). Line: *"AI writes code; companies hire people who can check it."* |
| 48–55 min | **The 9-week program** | Walk the week-by-week list. Connect it to what they saw: "Terraform = Week 4, pipeline = Week 6, Kubernetes + Argo CD = Weeks 7–8." Mention: recordings, WhatsApp support, weekly labs, GitHub portfolio. |
| 55–60 min | **Q&A + close** | Answer questions. Then: fee ₹35,000, two instalments, 9 weeks, 1.5 hrs/day Mon–Fri. Offer a start date. **Ask for a decision, don't wait for one.** |

---

## Talking points to keep handy

- **Why one-on-one over an institute?** Pace set to you, your doubts answered live, real production experience — not a slide reader.
- **Is DevOps good for freshers?** Yes, but entry is usually via Cloud/Support roles first; the portfolio is what gets interviews.
- **Will I get a job?** Honest answer: no one can guarantee it. You get skills, 8+ real projects on GitHub, and a clear path. (Don't promise placement.)
- **Do I need coding?** Basic logic is enough; Python is taught from scratch at automation level.
- **AWS cost?** Free tier for most labs; ~$5–15 total in Kubernetes weeks if you clean up.

## If something breaks live

Don't panic — **it's actually a great teaching moment.** Read the error aloud, check the Actions log, fix it. "This is literally the job." Have a screenshot of a green pipeline + v2 site as a backup.

## After the call

- Send the WhatsApp program summary within 1 hour
- Follow up once after 2 days if no reply
- Clean up: `terraform destroy` when you no longer need the demo setup
