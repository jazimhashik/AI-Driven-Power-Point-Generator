from google import genai
import os

# Initialize Gemini client
client = genai.Client(
    api_key=os.getenv("GOOGLE_API_KEY")
)


def generate_ppt_content(user_text, slide_count, content_depth):
    """Generate professional PPT content with detailed, well-structured prompts"""
    
    # Ensure numeric slide count
    try:
        num_slides = int(slide_count)
    except:
        num_slides = 5
    
    # Configure content generation based on depth
    if content_depth == "short":
        content_instructions = f"""
CONTENT STYLE: Bullet Points (Concise but Complete)
- Write EXACTLY 5 bullet points per slide — no more, no less
- Each bullet: 8-15 words — short but meaningful
- Use strong action verbs, key metrics and data points
- Format: Crisp phrases that deliver clear takeaways
- Every bullet must convey one distinct idea

EXAMPLE SLIDE:
Strategic Growth Overview
• Revenue surged 35% year-over-year reaching $48M milestone
• Customer base expanded to 12,000 active enterprise accounts
• Three new product lines launched across APAC and EU markets
• Employee satisfaction scores improved from 72% to 91%
• Operational costs reduced by $2.3M through process automation"""
    
    elif content_depth == "balanced":
        content_instructions = f"""
CONTENT STYLE: Balanced (Bullet Points + Explanatory Sentences)
- Write EXACTLY 5 bullet points per slide
- Each bullet: 20-35 words — start with a bold key phrase, then add a sentence of explanation
- Mix data/statistics with contextual insights and analysis
- Each bullet should read as a mini-paragraph: "Key Point: supporting explanation with detail"
- Cover different angles per slide (what, why, how, impact, next step)

EXAMPLE SLIDE:
Market Expansion Strategy
• Revenue Growth: Annual revenue increased 35% to $48M, driven primarily by strong adoption in the enterprise segment and expansion into three new geographic markets
• Customer Retention: Retention rates improved from 78% to 92% after implementing personalized onboarding journeys, reducing average churn by 14 percentage points
• Product Innovation: Launched AI-powered analytics dashboard that became the most adopted feature within 90 days, with 8,000 daily active users across all tiers
• Cost Efficiency: Automated 60% of manual operational workflows, saving $2.3M annually while reducing average processing time from 48 hours to just 4 hours
• Team Scaling: Grew engineering team from 45 to 120 across three global offices, maintaining velocity above 95% sprint completion rate throughout the growth phase"""
    
    else:  # detailed
        content_instructions = f"""
CONTENT STYLE: Detailed (Comprehensive Paragraphs and Rich Content)
- Write EXACTLY 4-5 content points per slide (NOT more — must fit on one slide)
- Each point: 40-60 words — a full mini-paragraph with context, data, examples, and outcomes
- Provide specific numbers, percentages, timelines, case studies, and concrete evidence
- Each point should tell a small story: background → action → result → impact
- Use rich professional language, avoid vague statements
- IMPORTANT: Do NOT exceed 5 points — the content must fit one slide without overflow
- CRITICAL: Every bullet point MUST be a COMPLETE sentence or thought. NEVER end a bullet with "..." or leave it unfinished. Every point must have a clear conclusion.

EXAMPLE SLIDE:
Digital Transformation Results
• Enterprise Cloud Migration: Over 8 months, successfully migrated 15 departments to cloud infrastructure, reducing IT operational costs by 40% ($3.2M saved), achieving 99.9% uptime SLA, and enabling seamless remote collaboration for 5,000+ employees across all offices
• Customer Experience Redesign: Conducted in-depth journey mapping across 23 customer touchpoints from awareness to advocacy, implementing targeted improvements that raised NPS from 32 to 67 and boosted customer lifetime value by 156% within 12 months
• Revenue Diversification: Launched three new product lines targeting previously underserved mid-market segments, generating $12M in first-year revenue at healthy 45% gross margins, establishing clear market leadership in each category
• Talent and Culture Overhaul: Redesigned the hiring pipeline and culture programs company-wide, growing engineering headcount from 45 to 120 across three offices while achieving an employee engagement score of 4.6 out of 5.0"""

    prompt = f"""You are a professional presentation designer. Create a polished, executive-quality PowerPoint presentation.

TOPIC: {user_text}

REQUIREMENTS:
- Create EXACTLY {num_slides} content slides (not counting title slide)
- Use "SLIDE_BREAK" on its own line to separate each slide
- Each slide needs: a clear TITLE (3-7 words) followed by bullet points
- Bullets must start with • character
- Make content insightful, specific, and professional
- Include relevant data, statistics, or concrete examples
- Ensure logical flow from slide to slide

{content_instructions}

STRICT OUTPUT FORMAT (follow exactly):
SLIDE_BREAK
Short Title Here
• First bullet point content
• Second bullet point content
• Third bullet point content
• Fourth bullet point content
• Fifth bullet point content

SLIDE_BREAK
Another Short Title
• Bullet point with content
• Bullet point with content
• Bullet point with content
• Bullet point with content
• Bullet point with content

CRITICAL RULES:
1. Start output with SLIDE_BREAK — no text before it
2. Slide titles MUST be SHORT: 3-6 words MAXIMUM. Never write titles longer than 50 characters
3. Do NOT include slide numbers or "Slide 1:" prefixes in titles
4. Do NOT use markdown (no **, no ##, no #)
5. Every bullet MUST start with the • character
6. Content must tell a cohesive, logical story across slides
7. NEVER repeat the same point across slides
8. NEVER leave any bullet point incomplete or trailing off with "..." — every sentence must be fully finished with a clear ending

Slide flow for {num_slides} slides:
1. Introduction/Overview
2. Background/Current State
3. Key Analysis/Findings
4. Evidence/Data/Details
5. Recommendations/Next Steps
(additional slides: deeper supporting details)

Now generate exactly {num_slides} professional, content-rich slides on "{user_text}":
"""

    try:
        response = client.models.generate_content(
            model="models/gemini-2.5-flash",
            contents=prompt
        )
        
        # Clean up the response
        content = response.text
        
        # Remove any markdown code blocks if present
        if "```" in content:
            # Extract content from code blocks
            parts = content.split("```")
            # Take alternating parts (outside code blocks)
            cleaned_parts = []
            for i, part in enumerate(parts):
                if i % 2 == 0:  # Outside code block
                    cleaned_parts.append(part)
                else:  # Inside code block - check if it's the main content
                    if "SLIDE_BREAK" in part:
                        # Remove language identifier if present
                        lines = part.split('\n')
                        if lines and not lines[0].strip().startswith('•') and not lines[0].strip().startswith('SLIDE'):
                            part = '\n'.join(lines[1:])
                        cleaned_parts.append(part)
            content = ''.join(cleaned_parts)
        
        # Remove markdown formatting
        content = content.replace("**", "").replace("##", "").replace("# ", "")
        
        # Ensure proper SLIDE_BREAK format
        content = content.replace("SLIDE_BREAK:", "SLIDE_BREAK")
        content = content.replace("SLIDE BREAK", "SLIDE_BREAK")
        
        # Validate content has slides
        if "SLIDE_BREAK" not in content:
            # Try to detect slides by patterns
            content = content.replace("\n\n\n", "\nSLIDE_BREAK\n")
        
        return content.strip()
        
    except Exception as e:
        print(f"AI generation error: {e}")
        # Return professional fallback content
        return generate_fallback_content(user_text, num_slides)


def generate_fallback_content(topic, num_slides):
    """Generate professional fallback content when AI fails"""
    title = topic[:50] if topic else "Professional Presentation"
    
    fallback_slides = [
        f"""SLIDE_BREAK
Introduction to {title}
• Overview of key concepts and objectives for this presentation
• Understanding the context and importance of {title}
• What you will learn and the value it provides
• Setting the foundation for detailed analysis
• Expected outcomes and actionable insights""",
        
        f"""SLIDE_BREAK
Current State Analysis
• Present situation assessment and baseline metrics
• Key challenges and opportunities identified
• Stakeholder perspectives and requirements
• Market dynamics and competitive landscape
• Critical success factors for consideration""",
        
        f"""SLIDE_BREAK
Key Findings and Insights
• Primary discoveries from research and analysis
• Data-driven insights supporting main conclusions
• Patterns and trends observed in the data
• Comparative analysis with industry benchmarks
• Strategic implications of findings""",
        
        f"""SLIDE_BREAK
Strategic Recommendations
• Recommended approach based on analysis
• Implementation priorities and quick wins
• Resource requirements and timeline estimates
• Risk mitigation strategies recommended
• Success metrics and KPIs to track""",
        
        f"""SLIDE_BREAK
Implementation Roadmap
• Phase 1: Foundation and quick wins (0-3 months)
• Phase 2: Core implementation (3-6 months)
• Phase 3: Optimization and scaling (6-12 months)
• Key milestones and checkpoints along the way
• Change management considerations""",
        
        f"""SLIDE_BREAK
Expected Benefits and ROI
• Quantified benefits and value proposition
• Cost savings and efficiency improvements
• Revenue growth opportunities identified
• Competitive advantages gained
• Long-term strategic value creation""",
        
        f"""SLIDE_BREAK
Next Steps and Action Items
• Immediate actions required this week
• Key decisions needed from stakeholders
• Resources and support requirements
• Follow-up meetings and checkpoints
• Timeline for final deliverables"""
    ]
    
    # Return requested number of slides
    return "\n\n".join(fallback_slides[:min(num_slides, len(fallback_slides))])
